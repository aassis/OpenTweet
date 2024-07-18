import UIKit

final class ThreadViewControllerBuilder {
    static func build(tappedTweet: Tweet, thread: [Tweet]) -> UIViewController {
        let viewModel = ThreadViewModel(tappedTweet: tappedTweet, thread: thread)
        let viewController = ThreadViewController(viewModel: viewModel)
        return viewController
    }
}
