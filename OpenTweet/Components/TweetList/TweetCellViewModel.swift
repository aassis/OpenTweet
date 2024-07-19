import Foundation
import UIKit

protocol TweetCellViewModelProtocol {
    var authorName: String { get }
    var avatarUrlString: String? { get }
    var dateShortString: String? { get }
    var contentAttributedString: NSAttributedString? { get }
    var avatarImage: UIImage? { get }
    func saveAvatarImage(image: UIImage?)
}

final class TweetCellViewModel: TweetCellViewModelProtocol {
    private let tweet: Tweet

    init(tweet: Tweet) {
        self.tweet = tweet
    }

    var authorName: String {
        tweet.author
    }

    var avatarUrlString: String? {
        tweet.avatar
    }

    var dateShortString: String? {
        return DateFormatter.shortDateFormatter.string(from: tweet.date)
    }

    private var _contentAttributedString: NSAttributedString?
    lazy var contentAttributedString: NSAttributedString? = {
        if let attString = _contentAttributedString {
            return attString
        } else {
            let attString = tweetContent()
            _contentAttributedString = attString
            return attString
        }
    }()

    private var _avatarImage: UIImage?
    var avatarImage: UIImage? {
        _avatarImage
    }

    func saveAvatarImage(image: UIImage?) {
        self._avatarImage = image
    }

    private func tweetContent() -> NSAttributedString {
        /**
         This function searches for a handle in the provided string using a regular expression, and applies a different weighted font and color for the range where the handle is found.
         */
        func highlightHandle(fromContentText text: String) -> NSAttributedString {
            // Defines the pattern we're looking for, in this case, any text and underscore followed by @.
            let pattern = "@[a-zA-Z0-9_]+"

            // Here I am force unwrapping the regular expression try catch because I am sure it will not fail
            let regex = try! NSRegularExpression(pattern: pattern, options: [])

            // To represent the length for the string, we're using the utf16 code unit count so we get the correct range in case the original text contains emojis.
            let matches = regex.matches(in: text, range: NSRange(location: 0, length: text.utf16.count))

            // Instantiating the mutable attributed string and the attribute dictionary we'll use
            let attributedString = NSMutableAttributedString(string: text)
            let boldAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: ViewCodeConstants.fontSize),
                                                                .foregroundColor: UIColor.blue]

            // Iterating through every match the regular expression found within the original text, and applying the bold attribute in the match's range
            for match in matches {
                attributedString.addAttributes(boldAttribute, range: match.range)
            }

            return attributedString
        }

        return highlightHandle(fromContentText: tweet.content)
    }
}
