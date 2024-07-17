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
    private var posts: [Tweet] = []

    init() {
        if let data = FileReader.getFileData(forFileName: "timeline", fileExtension: "json") {
            if let decoded = try? JSONDecoder().decode(Timeline.self, from: data) {
                self.tweets = decoded.timeline
                posts = tweets.filter({ $0.inReplyTo == nil })
            }
        }
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItems() -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.CellIdentifier.name) as? TweetCell {
            let tweet = posts[indexPath.row]
            let tweetViewModel = TweetCellViewModel(tweet: tweet)
            cell.setupWith(tweet: tweetViewModel)
            return cell
        }
        return UITableViewCell()
    }
}
