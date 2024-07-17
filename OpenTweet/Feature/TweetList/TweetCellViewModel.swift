import Foundation

protocol TweetCellViewModelProtocol {
    var authorName: String { get }
    var dateShortString: String? { get }
    var tweetContent: String { get }
}

final class TweetCellViewModel: TweetCellViewModelProtocol {
    private let tweet: Tweet

    init(tweet: Tweet) {
        self.tweet = tweet
    }

    var authorName: String {
        tweet.author
    }

    var dateShortString: String? {
        if let date = dateFormatter.date(from: tweet.date) {
            return shortDateFormatter.string(from: date)
        }
        return nil
    }

    var tweetContent: String {
        tweet.content
    }

    private lazy var dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()

    private lazy var shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}
