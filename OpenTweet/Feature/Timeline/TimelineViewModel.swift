import Foundation
import Combine
import UIKit
import Swinject

// MARK: - Protocol
protocol TimelineViewModelProtocol {
    var service: NetworkService<TimelineEndpoint> { get }
    func loadTimeline() -> AnyPublisher<Bool, Error>

    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func getThreadViewController(forIndexPath indexPath: IndexPath) -> UIViewController
}

// MARK: - Implementation
final class TimelineViewModel: TimelineViewModelProtocol {

    // MARK: - Protocol required properties
    var service: NetworkService<TimelineEndpoint>

    // MARK: - Local Properties
    private var timeline: [Tweet] = []
    private var threads: [String: [Tweet]] = [:]
    private var storedCellViewModels: [String: TweetCellViewModelProtocol] = [:]

    // MARK: - Init

    init(service: NetworkService<TimelineEndpoint>) {
        self.service = service
    }

    // MARK: - Protocol functions
    func loadTimeline() -> AnyPublisher<Bool, Error> {
        return service.request(.getTimeline, type: Timeline.self).compactMap({ response in
            self.timeline = response.timeline.sorted(by: { $0.date < $1.date })
            return .some(true)
        }).eraseToAnyPublisher()
    }

    func getThreadViewController(forIndexPath indexPath: IndexPath) -> UIViewController {
        /// Instantiate the root node for our search
        let tappedTweet = timeline[indexPath.row]
        var tweetThread: [Tweet] = []

        /// Let's check if the tapped tweet is a reply or an original post
        if let replyId = tappedTweet.inReplyTo {
            /// Here I decided to do a quick filter, retrieving only the tweet replied to by the tapped one
            if let originalTweet = timeline.first(where: { $0.id == replyId }) {
                tweetThread.append(originalTweet)
            }
            /// Add the tapped tweet to the array for presentation
            tweetThread.append(tappedTweet)
        } else {
            /// If there is already a thread for this root node, let's just skip the search and assign it
            if let cachedThread = threads[tappedTweet.id] {
                tweetThread = cachedThread
            } else {
                /// Otherwise, we call our DFS and store the result in our local dict
                tweetThread = buildReplyThread(from: timeline, startingFromOriginalTweet: tappedTweet)
                threads[tappedTweet.id] = tweetThread
            }
        }

        return Container.sharedContainer.resolve(ThreadViewController.self, arguments: tappedTweet, tweetThread)!
    }

    // MARK: - TableViewDataSource functions
    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItems() -> Int {
        return timeline.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.CellIdentifier.name) as? TweetCell {

            let tweet = timeline[indexPath.row]
            let cellViewModel = getCellViewModel(forTweet: tweet)
            cell.setupWith(viewModel: cellViewModel)

            return cell
        }
        return UITableViewCell()
    }

    private func getCellViewModel(forTweet tweet: Tweet) -> TweetCellViewModelProtocol {
        if let cellViewModel = storedCellViewModels[tweet.id] {
            return cellViewModel
        } else {
            let cellViewModel = Container.sharedContainer.resolve(TweetCellViewModelProtocol.self, argument: tweet)!
            storedCellViewModels[tweet.id] = cellViewModel
            return cellViewModel
        }
    }

    // MARK: - Private utility functions

    /// Depth first search for the tweets in a thread starting from the original post
    private func buildReplyThread(from timeline: [Tweet], startingFromOriginalTweet originalTweet: Tweet) -> [Tweet] {
        var thread: [Tweet] = []

        /// We use this recursive function to add all descendants to the thread
        func addReplies(for originalTweet: Tweet) {
            for item in timeline {
                if item.inReplyTo == originalTweet.id {
                    thread.append(item)
                    addReplies(for: item)
                }
            }
        }

        thread.append(originalTweet)
        addReplies(for: originalTweet)

        return thread
    }
}
