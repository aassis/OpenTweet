import UIKit

final class TimelineViewControllerBuilder: BuilderProtocol {
    static func build() -> UIViewController {
        let viewModel = TimelineViewModel()
        let viewController = TimelineViewController(viewModel: viewModel)
        return viewController
    }
}
