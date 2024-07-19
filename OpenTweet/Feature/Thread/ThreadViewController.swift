import UIKit
import Combine

final class ThreadViewController: UIViewController {

    private let viewModel: ThreadViewModelProtocol

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
        tweetListView.tableView.delegate = self
        tweetListView.tableView.dataSource = self
        tweetListView.tableView.register(TweetCell.self, forCellReuseIdentifier: TweetCell.CellIdentifier.name)
        tweetListView.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.highlightSourceTweetIn(tweetListView.tableView)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.CellIdentifier.name) as? TweetCell {
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
