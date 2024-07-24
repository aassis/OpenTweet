import Combine
import Swinject
import UIKit

// MARK: - Protocol
protocol ThreadViewModelProtocol {
    func loadThread() -> AnyPublisher<Bool, Error>
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func getViewModelForCellAt(indexPath: IndexPath) -> TweetCellViewModelProtocol
    func highlightSourceTweetIn(_ tableView: UITableView)
}

// MARK: - Implementation
final class ThreadViewModel: ThreadViewModelProtocol {

    // MARK: - Local Properties
    private let store: TweetStoreProtocol
    private let tappedTweet: Tweet
    private var thread: [Tweet] = []

    // MARK: - Init
    init(store: TweetStoreProtocol,
         tappedTweet: Tweet) {
        self.store = store
        self.tappedTweet = tappedTweet
    }

    func loadThread() -> AnyPublisher<Bool, Error> {
        return store.searchThreadForTweet(tappedTweet).compactMap { thread in
            self.thread = thread
            return true
        }.eraseToAnyPublisher()
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
        return store.getCellViewModelFor(tweet: tweet)
    }

    func highlightSourceTweetIn(_ tableView: UITableView) {
        if let index = thread.firstIndex(where: { $0.id == tappedTweet.id }) {
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
        }
    }
}
