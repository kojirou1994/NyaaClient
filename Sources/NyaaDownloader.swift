//
//  NyaaDownloader.swift
//  NyaaClient
//
//  Created by 王宇 on 2016/10/5.
//
//

import Foundation

class NyaaDownloader: NyaaParserDelegate {
	
	var path: String
	
	init(path: String = NSHomeDirectory() + "/Torrents/") {
		self.path = path
		try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
	}
	
	func smartDownload(keyword: String) {
		let parser = NyaaParser(keyword: keyword)
		parser.delegate = self
		do {
			try parser.parse()
		} catch {
			
		}
	}
	
	func download(url: String, filename: String? = nil) {
		URLSession.shared.downloadTask(with: URL(string: url)!) { (path, response, error) in
			guard error == nil, path != nil else {
				return
			}
			do {
				try FileManager.default.copyItem(at: path!, to: URL.init(fileURLWithPath: self.path + (filename == nil ? (response?.suggestedFilename)! : filename!)))
			} catch let error as NSError {
				//print(error.localizedDescription)
			}
		}.resume()
	}
	
	func didGet(links: [String], inPage: Int) {
		links.forEach({ download(url: $0) })
	}
	
	func parseDidEnd() {
		
	}
}
