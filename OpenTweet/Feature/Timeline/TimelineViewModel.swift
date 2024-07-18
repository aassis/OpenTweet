import Foundation
import Combine
import UIKit

protocol TimelineViewModelProtocol {
    var service: NetworkService<TimelineEndpoint> { get }
    func loadTimeline() -> AnyPublisher<Bool, Error>

    func numberOfSections() -> Int
    func numberOfItems() -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

final class TimelineViewModel: TimelineViewModelProtocol {
    var service: NetworkService<TimelineEndpoint>

    private var tweets: [Tweet] = []
    private var posts: [Tweet] = []

    /// For the publishers declared in the protocol to work, we need to have them return a reference to an actual @Published property's Publisher
    @Published private var finishedLoading: Bool = false
    var finishedLoadingPublisher: Published<Bool>.Publisher { $finishedLoading }

    init(service: NetworkService<TimelineEndpoint>) {
        self.service = service
    }

    func loadTimeline() -> AnyPublisher<Bool, Error> {
        return service.request(.getTimeline, type: Timeline.self).compactMap({ response in
            self.tweets = response.timeline.sorted(by: { $0.date < $1.date })
            self.posts = response.timeline.filter({ $0.inReplyTo == nil })
            return .some(true)
        }).eraseToAnyPublisher()
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItems() -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.CellIdentifier.name) as? TweetCell {
            let tweet = posts[indexPath.row]
            let tweetViewModel = TweetCellViewModel(tweet: tweet)
            cell.setupWith(tweet: tweetViewModel)
            return cell
        }
        return UITableViewCell()
    }
}
