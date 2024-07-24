import Foundation
import Combine
import UIKit
import Swinject

// MARK: - Protocol
protocol TimelineViewModelProtocol {
    func loadContent() -> AnyPublisher<Bool, Error>
    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func getViewModelForCellAt(indexPath: IndexPath) -> TweetCellViewModelProtocol
    func getThreadViewControllerFor(indexPath: IndexPath) -> UIViewController
}

// MARK: - Implementation
final class TimelineViewModel: TimelineViewModelProtocol {

    private let store: TweetStoreProtocol
    private var timeline: [Tweet] = []
    private var cancellables = Set<AnyCancellable>()

    init(store: TweetStoreProtocol) {
        self.store = store
    }

    // MARK:

    func loadContent() -> AnyPublisher<Bool, Error> {
        return self.store.loadTimeline()
            .compactMap { timeline in
                self.timeline = timeline
                return true
            }.eraseToAnyPublisher()
    }

    func getThreadViewControllerFor(indexPath: IndexPath) -> UIViewController {
        let tweet = timeline[indexPath.row]
        return Container.sharedContainer.resolve(ThreadViewController.self, argument: tweet)!
    }

    // MARK: - TableViewDataSource functions
    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItems() -> Int {
        return timeline.count
    }

    func getViewModelForCellAt(indexPath: IndexPath) -> TweetCellViewModelProtocol {
        let tweet = timeline[indexPath.row]
        return store.getCellViewModelFor(tweet: tweet)
    }
}
