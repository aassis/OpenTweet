@testable import OpenTweet
import Combine
import Swinject
import XCTest

final class TimelineViewModelTests: XCTestCase {
    private var timelineViewModel: TimelineViewModelProtocol?

    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        self.cancellables = []
    }

    override func tearDown() {
        super.tearDown()
        self.cancellables = nil
        self.timelineViewModel = nil
    }

    func testLoadingTimelineSuccessful() {
        self.timelineViewModel = Container.sharedContainer.resolve(TimelineViewModelProtocol.self)

        var timelineLoaded: Bool = false

        timelineViewModel?.loadTimeline()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { loaded in
                timelineLoaded = loaded
            }).store(in: &cancellables)

        let indexPath = IndexPath(row: 0, section: 0)
        let vc = timelineViewModel?.getThreadViewController(forIndexPath: indexPath)

        XCTAssertTrue(timelineLoaded)
        XCTAssertEqual(timelineViewModel?.numberOfSections(), 1)
        XCTAssertEqual(timelineViewModel?.numberOfItems(), 7)
        XCTAssertTrue(vc is ThreadViewController)
    }
}
