//
//  NyaaDownloader.swift
//  NyaaClient
//
//  Created by 王宇 on 2016/10/5.
//
//

import Foundation
import Dispatch

class NyaaDownloader: NyaaParserDelegate {
	
	var path: String
	
	var tasks = Dictionary<String, DownloadState>()
	
	enum DownloadState {
		case downloading
		case finished
		case failed
	}
	
	init(path: String = NSHomeDirectory() + "/Torrents/") {
		self.path = path
		try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
	}
	
	func smartDownload(_ keyword: String) {
		let parser = NyaaParser(keyword: keyword)
		parser.delegate = self
		do {
			try parser.parse()
		} catch {
			
		}
	}
	
	func download(url: URL?, filename: String? = nil) {
		guard let url = url else {
			return
		}
		_ = DispatchQueue(label: "change tasks").sync(flags: DispatchWorkItemFlags.barrier) {
			self.tasks[url.absoluteString] = .downloading
		}
		
		URLSession.shared.downloadTask(with: url) { (path, response, error) in
			guard error == nil, let path = path, let response = response else {
				return
			}
			do {
				let outputFilename = filename == nil ? (response.suggestedFilename ?? url.lastPathComponent) : filename!
				try FileManager.default.copyItem(at: path, to: URL(fileURLWithPath: self.path + outputFilename))
				print(outputFilename + "......Completed")
				_ = DispatchQueue(label: "change tasks").sync(flags: DispatchWorkItemFlags.barrier) {
					self.tasks[url.absoluteString] = .finished
				}
			} catch _ as NSError {
				//print(error.localizedDescription)
				_ = DispatchQueue(label: "change tasks").sync(flags: DispatchWorkItemFlags.barrier) {
					self.tasks[url.absoluteString] = .failed
				}
			}
		}.resume()
	}
	
	func didGet(links: [String], inPage: Int) {
		links.forEach({ download(url: URL(string: $0)) })
	}
	
	func parseDidEnd() {
		
	}
}
