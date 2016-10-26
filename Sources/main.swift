import Foundation

if CommandLine.arguments.count == 1 {
	print("No Keyword!")
} else {
	let keyword = CommandLine.arguments[1..<CommandLine.arguments.count].joined(separator: " ")
	let downloader = NyaaDownloader()
	downloader.smartDownload(keyword: keyword)
	pause()
}
