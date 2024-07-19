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
    private var storedCellViewModels: NSMutableDictionary = NSMutableDictionary()

    // MARK: - Init
    init(tappedTweet: Tweet, thread: [Tweet], storedCellViewModels: NSMutableDictionary) {
        self.tappedTweet = tappedTweet
        self.thread = thread
        self.storedCellViewModels = storedCellViewModels
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
        return getCellViewModel(forTweet: tweet)
    }

    private func getCellViewModel(forTweet tweet: Tweet) -> TweetCellViewModelProtocol {
        if let cellViewModel = storedCellViewModels[tweet.id] as? TweetCellViewModelProtocol {
            return cellViewModel
        } else {
            let cellViewModel = Container.sharedContainer.resolve(TweetCellViewModelProtocol.self, argument: tweet)!
            storedCellViewModels[tweet.id] = cellViewModel
            return cellViewModel
        }
    }

    func highlightSourceTweetIn(_ tableView: UITableView) {
        if let index = thread.firstIndex(where: { $0.id == tappedTweet.id }) {
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
        }
    }
}
