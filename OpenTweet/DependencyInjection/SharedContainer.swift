import Swinject
import Foundation

extension Container {
    static let sharedContainer: Container = {
        let container = Container()

        // MARK: Network layer

        container.register(NetworkProviderProtocol.self, factory: { r in
            TimelineProviderMock()
        }).inObjectScope(.container)

        container.register(NetworkService<TimelineEndpoint>.self, factory: { r in
            let provider = r.resolve(NetworkProviderProtocol.self)!
            return NetworkService<TimelineEndpoint>(provider: provider)
        }).inObjectScope(.container)

        // MARK: Timeline

        container.register(TimelineViewModelProtocol.self, factory: { r in
            let service = r.resolve(NetworkService<TimelineEndpoint>.self)!
            return TimelineViewModel(service: service)
        }).inObjectScope(.transient)

        container.register(TimelineViewController.self, factory: { r in
            let viewModel = r.resolve(TimelineViewModelProtocol.self)!
            return TimelineViewController(viewModel: viewModel)
        }).inObjectScope(.transient)

        // MARK: Thread

        container.register(ThreadViewModelProtocol.self, factory: { (r: Resolver,
                                                                     tappedTweet: Tweet,
                                                                     thread: [Tweet],
                                                                     storedCellViewModels: NSMutableDictionary) in

            ThreadViewModel(tappedTweet: tappedTweet, thread: thread, storedCellViewModels: storedCellViewModels)
        }).inObjectScope(.transient)

        container.register(ThreadViewController.self, factory: { (r: Resolver,
                                                                  tappedTweet: Tweet,
                                                                  thread: [Tweet],
                                                                  storedCellViewModels: NSMutableDictionary) in
            let viewModel = r.resolve(ThreadViewModelProtocol.self,
                                      arguments: tappedTweet, thread, storedCellViewModels)!

            return ThreadViewController(viewModel: viewModel)
        }).inObjectScope(.transient)

        // MARK: TweetCell

        container.register(TweetCellViewModelProtocol.self, factory: { (r: Resolver, tweet: Tweet) in
            TweetCellViewModel(tweet: tweet)
        }).inObjectScope(.transient)

        return container
    }()
}
