import UIKit

final class TweetListView: UIView {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.clipsToBounds = false
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewCode()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - ViewCode

extension TweetListView: ViewCode {
    func setupViewCode() {
        buildHierarchy()
        buildConstraints()
        additionalConfiguration()
    }

    func buildHierarchy() {
        self.addSubview(tableView)
    }

    func buildConstraints() {
        tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: ViewCodeConstants.sidePaddings).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: ViewCodeConstants.sidePaddings).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -ViewCodeConstants.sidePaddings).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -ViewCodeConstants.sidePaddings).isActive = true
    }

    func additionalConfiguration() {
        self.backgroundColor = .white
    }
}
