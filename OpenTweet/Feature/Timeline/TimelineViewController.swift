import UIKit
import Combine

final class TimelineViewController: UIViewController {

    private let viewModel: TimelineViewModelProtocol

    private var cancellable = Set<AnyCancellable>()

    private let transitionAnimation = ExpandTransition()

    init(viewModel: TimelineViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var tweetListView: TweetListView = {
        let view = TweetListView(frame: .zero)
        return view
    }()

    override func loadView() {
        self.view = tweetListView
    }

	override func viewDidLoad() {
		super.viewDidLoad()
        self.title = "Timeline"
        navigationController?.delegate = self
        tweetListView.tableView.delegate = self
        tweetListView.tableView.dataSource = self
        tweetListView.tableView.register(TweetCell.self, forCellReuseIdentifier: TweetCell.CellIdentifier.name)

        viewModel.loadTimeline()
            .sink { completion in
                switch completion {
                case .failure:
                    // present error
                    break
                default:
                    break
                }
            } receiveValue: { loaded in
                self.tweetListView.tableView.reloadData()
            }.store(in: &cancellable)
	}
}

// MARK: - TableViewDataSource

extension TimelineViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.CellIdentifier.name) as? TweetCell {
            let cellViewModel = viewModel.getViewModelForCellAt(indexPath: indexPath)
            cell.setupWith(viewModel: cellViewModel)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - TableViewDelegate

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = viewModel.getThreadViewController(forIndexPath: indexPath)
        vc.transitioningDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UINavigationControllerDelegate

extension TimelineViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimation.popStyle = (operation == .pop)
        return transitionAnimation
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension TimelineViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimation
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionAnimation
    }
}
