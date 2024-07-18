import Combine
import UIKit

// MARK: - Protocol
protocol ThreadViewModelProtocol {
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func highlightSourceTweetIn(_ tableView: UITableView)
}

// MARK: - Implementation
final class ThreadViewModel: ThreadViewModelProtocol {

    // MARK: - Local Properties
    private let tappedTweet: Tweet
    private let thread: [Tweet]

    // MARK: - Init
    init(tappedTweet: Tweet, thread: [Tweet]) {
        self.tappedTweet = tappedTweet
        self.thread = thread
    }

    // MARK: - TableViewDataSource functions
    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItems() -> Int {
        return thread.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.CellIdentifier.name) as? TweetCell {
            let tweet = thread[indexPath.row]
            let tweetViewModel = TweetCellViewModel(tweet: tweet)
            cell.setupWith(viewModel: tweetViewModel)
            return cell
        }
        return UITableViewCell()
    }

    func highlightSourceTweetIn(_ tableView: UITableView) {
        if let index = thread.firstIndex(where: { $0.id == tappedTweet.id }) {
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
        }
    }
}
