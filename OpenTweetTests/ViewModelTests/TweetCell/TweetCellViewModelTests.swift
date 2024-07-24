@testable import OpenTweet
import Combine
import Swinject
import XCTest

final class TweetCellViewModelTests: XCTestCase {
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

    func testCellViewModelHasCorrectInformation() {
        self.timelineViewModel = Container.sharedContainer.resolve(TimelineViewModelProtocol.self)

        timelineViewModel?.loadContent()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { _ in }).store(in: &cancellables)

        let indexPath = IndexPath(row: 0, section: 0)
        let cellViewModel = timelineViewModel?.getViewModelForCellAt(indexPath: indexPath)

        XCTAssertEqual(cellViewModel?.authorName, "@randomInternetStranger")
        XCTAssertEqual(cellViewModel?.avatarUrlString, "https://i.imgflip.com/ohrrn.jpg")
        XCTAssertEqual(cellViewModel?.dateShortString, "Sep 29, 3:41 PM")
        XCTAssertNotNil(cellViewModel?.contentAttributedString)
    }
}
