//
//  NyaaParser.swift
//  NyaaClient
//
//  Created by 王宇 on 2016/10/5.
//
//

import Foundation
import Scrape

enum NyaaError: Error {
	
	case networkError
	
	case htmlParserError
}

class NyaaParser {
	
	let baseUrl: String
	
	var pageCount: Int = 1
	
	var currentPage: Int = 1
	
	weak var delegate: NyaaParserDelegate?
	
	init(keyword: String) {
		baseUrl = "http://www.nyaa.se/?page=search&cats=0_0&filter=0&term=" + keyword.replacingOccurrences(of: " ", with: "+")
	}
	
	func parse() throws {
		try parse(index: currentPage)
		while currentPage < pageCount {
			currentPage += 1
			try parse(index: currentPage)
		}
		delegate?.parseDidEnd()
	}
	
	private func parse(index: Int) throws {
		guard let data = try? Data(contentsOf: URL(string: baseUrl + "&offset=\(index)")!) else {
			throw NyaaError.networkError
		}
		guard let document = HTMLDocument.init(html: data, encoding: .utf8) else {
			throw NyaaError.htmlParserError
		}
		if index == 1 {
			if let link = document.element(atXPath: "//div[@class='rightpages']/a[last()]") {
					getPageCount(url: "http:" + (link["href"] ?? ""))
			}
			
		}
		let results = document.search(byCSSSelector: "td.tlistdownload")
		let rawlinks = results.map({ $0.element(atCSSSelector: "a")?["href"] ?? "" }).filter({ $0 != "" })
		let links = rawlinks.map({ (link) -> String in
			if !link.hasPrefix("http:") {
				return "http:" + link
			} else {
				return link
			}
		})
		delegate?.didGet(links: links, inPage: currentPage)
	}
	
	private func getPageCount(url: String) {
		if let offset = URLComponents(string: url)?.queryItems?.filter({ $0.name == "offset" }).first?.value,
		   let offsetInt = Int(offset) {
			pageCount = offsetInt
		}
	}
	
}

protocol NyaaParserDelegate: class {
	func didGet(links: [String], inPage: Int)
	func parseDidEnd()
}
