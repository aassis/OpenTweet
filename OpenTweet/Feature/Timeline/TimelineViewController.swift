import UIKit
import Combine

final class TimelineViewController: UIViewController {

    private let viewModel: TimelineViewModelProtocol

    private var cancellable = Set<AnyCancellable>()

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

extension TimelineViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.tableView(tableView, cellForRowAt: indexPath)
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
