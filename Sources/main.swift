import Foundation

//NyaaDownloader().download(url: "http://www.nyaa.se/?page=download&tid=755921")
import AEXML

let queryItems = URLComponents(string: "http://www.nyaa.se/?page=search&term=raw&offset=100")?.queryItems
let offset = queryItems?.filter({ $0.name == "offset" })
//http://www.nyaa.se/?page=search&cats=0_0&filter=0&term=orphans
//http://www.nyaa.se/?page=search&cats=0_0&filter=0&term=orphans+gundam
//http://www.nyaa.se/?page=search&cats=0_0&filter=0&term=orphans++gundam
func generateURL(key: String) -> String {
	return "http://www.nyaa.se/?page=search&cats=0_0&filter=0&term=" + key.replacingOccurrences(of: " ", with: "+")
}
//print(offset?[0].value)
//print(generateURL(key: "orphans gun"))
//try NyaaParser(keyword: "orphans").parse()

let downloader = NyaaDownloader()
downloader.smartDownload(keyword: "littlebaka")

pause()
