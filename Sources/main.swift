//
//  main.swift
//  NyaaClient
//
//  Created by 王宇 on 2016/10/5.
//
//

import Foundation

if CommandLine.arguments.count == 1 {
	print("No keywords input!")
} else {
	let keyword = CommandLine.arguments[1..<CommandLine.arguments.count].joined(separator: " ")
	let downloader = NyaaDownloader()
	downloader.smartDownload(keyword)
	RunLoop.current.run()
}
