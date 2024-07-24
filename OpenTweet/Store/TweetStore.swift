import UIKit
import Combine
import Swinject

protocol TweetStoreProtocol {
    func getCellViewModelFor(tweet: Tweet) -> TweetCellViewModelProtocol
    func loadTimeline() -> AnyPublisher<[Tweet], Error>
    func searchThreadForTweet(_ tappedTweet: Tweet) -> AnyPublisher<[Tweet], Error>
}

final class TweetStore: TweetStoreProtocol {
    // MARK: - Local Properties
    private let service: NetworkService<TimelineEndpoint>
    private var timeline: [Tweet] = []
    private var threads: [String: [Tweet]] = [:]

    // MARK: - Init

    init(service: NetworkService<TimelineEndpoint>) {
        self.service = service
    }

    // MARK: - Protocol functions
    func loadTimeline() -> AnyPublisher<[Tweet], Error> {
        return service.request(.getTimeline, type: Timeline.self).compactMap({ response in
            self.timeline = response.timeline.sorted(by: { tweet1, tweet2 in
                return tweet1.date < tweet2.date
            })
            return self.timeline
        }).eraseToAnyPublisher()
    }

    func searchThreadForTweet(_ tappedTweet: Tweet) -> AnyPublisher<[Tweet], Error> {
        Future({ [weak self] promise in
            guard let self = self else { return }

            var tweetThread = [Tweet]()

            if let thread = self.threads[tappedTweet.id] {
                tweetThread = thread
            } else {
                tweetThread = self.getThreadFor(tappedTweet: tappedTweet)
                threads[tappedTweet.id] = tweetThread
            }
            promise(.success(tweetThread))
        }).eraseToAnyPublisher()
    }

    private func getThreadFor(tappedTweet: Tweet) -> [Tweet] {
        /// Instantiate the array to store the thread we want
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
            /// If there is already a thread for tappedTweet, let's just skip the search and assign it
            if let cachedThread = threads[tappedTweet.id] {
                tweetThread = cachedThread
            } else {
                /// Otherwise, we call our DFS and store the result in our local dict
                tweetThread = buildReplyThread(from: timeline, startingFromOriginalTweet: tappedTweet)
            }
        }

        threads[tappedTweet.id] = tweetThread
        return tweetThread
    }

    func getCellViewModelFor(tweet: Tweet) -> TweetCellViewModelProtocol {
        return Container.sharedContainer.resolve(TweetCellViewModelProtocol.self, argument: tweet)!
    }

    // MARK: - Utility functions

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
