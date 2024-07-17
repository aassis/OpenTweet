import Foundation
import UIKit

protocol TimelineViewModelProtocol {
    var tweets: [Tweet] { get }

    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

final class TimelineViewModel: TimelineViewModelProtocol {
    private(set) var tweets: [Tweet] = []

    init() {
        if let data = FileReader.getFileData(forFileName: "timeline", fileExtension: "json") {
            if let decoded = try? JSONDecoder().decode(Timeline.self, from: data) {
                self.tweets = decoded.timeline
            }
        }
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItems() -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.CellIdentifier.name) as? TweetCell {
            let tweet = tweets[indexPath.row]
            let tweetViewModel = TweetCellViewModel(tweet: tweet)
            cell.setupWith(tweet: tweetViewModel)
            return cell
        }
        return UITableViewCell()
    }
}
