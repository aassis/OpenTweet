import UIKit
import Combine

final class ThreadViewController: UIViewController {

    private let viewModel: ThreadViewModelProtocol

    private var cancellable = Set<AnyCancellable>()

    init(viewModel: ThreadViewModelProtocol) {
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
        self.navigationItem.setHidesBackButton(true, animated: false)
        tweetListView.tableView.delegate = self
        tweetListView.tableView.dataSource = self
        tweetListView.tableView.register(ThreadTweetCell.self, forCellReuseIdentifier: ThreadTweetCell.CellIdentifier.name)

        viewModel.loadThread()
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.highlightSourceTweetIn(tweetListView.tableView)
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
}

extension ThreadViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ThreadTweetCell.CellIdentifier.name) as? ThreadTweetCell {
            let cellViewModel = viewModel.getViewModelForCellAt(indexPath: indexPath)
            cell.setupWith(viewModel: cellViewModel)
            return cell
        }
        return UITableViewCell()
    }
}

extension ThreadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
