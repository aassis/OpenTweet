import Combine
import Swinject
import UIKit

// MARK: - Protocol
protocol ThreadViewModelProtocol {
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func getViewModelForCellAt(indexPath: IndexPath) -> TweetCellViewModelProtocol
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

    func getViewModelForCellAt(indexPath: IndexPath) -> TweetCellViewModelProtocol {
        let tweet = thread[indexPath.row]
        return Container.sharedContainer.resolve(TweetCellViewModelProtocol.self, argument: tweet)!
    }

    func highlightSourceTweetIn(_ tableView: UITableView) {
        if let index = thread.firstIndex(where: { $0.id == tappedTweet.id }) {
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
        }
    }
}
