import UIKit

final class TimelineViewControllerBuilder: BuilderProtocol {
    static func build() -> UIViewController {
        let provider = TimelineProviderMock()
        let service = NetworkService<TimelineEndpoint>(provider: provider)
        let viewModel = TimelineViewModel(service: service)
        let viewController = TimelineViewController(viewModel: viewModel)
        return viewController
    }
}
