import UIKit

final class TweetCell: UITableViewCell {
    struct CellIdentifier {
        static let name = "tweetCell"
    }

    struct Constants {
        static let defaultPadding: CGFloat = 8.0
        static let avatarHeightWidth: CGFloat = 40.0
        static let avatarCornerRadius: CGFloat = 20.0
        static let fontSize: CGFloat = 14.0
    }

    private lazy var labelAuthorName: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .bold)
        label.textColor = .black
        return label
    }()

    private lazy var labelContent: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize)
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        label.textColor = .darkGray
        return label
    }()

    private lazy var labelDate: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.fontSize)
        label.textColor = .lightGray
        return label
    }()

    private lazy var imageAvatar: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = Constants.avatarCornerRadius
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        return image
    }()

    func setupWith(tweet: TweetCellViewModelProtocol) {
        setupViewCode()
        labelAuthorName.text = tweet.authorName
        labelDate.text = tweet.dateShortString
        labelContent.attributedText = tweet.tweetContent(fontSize: Constants.fontSize)
    }
}

extension TweetCell: ViewCode {
    func setupViewCode() {
        buildHierarchy()
        buildConstraints()
        additionalConfiguration()
    }

    func buildHierarchy() {
        contentView.addSubview(imageAvatar)
        contentView.addSubview(labelAuthorName)
        contentView.addSubview(labelDate)
        contentView.addSubview(labelContent)
    }

    func buildConstraints() {
        let defaultPadding = Constants.defaultPadding
        let avatarHeightWidth = Constants.avatarHeightWidth

        imageAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: defaultPadding).isActive = true
        imageAvatar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: defaultPadding).isActive = true
        imageAvatar.widthAnchor.constraint(equalToConstant: avatarHeightWidth).isActive = true
        imageAvatar.heightAnchor.constraint(equalToConstant: avatarHeightWidth).isActive = true
        imageAvatar.heightAnchor.constraint(equalToConstant: avatarHeightWidth).isActive = true

        labelAuthorName.topAnchor.constraint(equalTo: imageAvatar.topAnchor).isActive = true
        labelAuthorName.leftAnchor.constraint(equalTo: imageAvatar.rightAnchor, constant: defaultPadding).isActive = true

        labelDate.topAnchor.constraint(equalTo: labelAuthorName.topAnchor).isActive = true
        labelDate.leftAnchor.constraint(equalTo: labelAuthorName.rightAnchor, constant: defaultPadding).isActive = true
        labelDate.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -defaultPadding).isActive = true

        labelContent.topAnchor.constraint(equalTo: labelAuthorName.bottomAnchor, constant: defaultPadding).isActive = true
        labelContent.leftAnchor.constraint(equalTo: labelAuthorName.leftAnchor).isActive = true
        labelContent.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -defaultPadding).isActive = true
        let constraint = labelContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -defaultPadding)
        constraint.priority = .defaultHigh
        constraint.isActive = true
    }

    func additionalConfiguration() {
        self.clipsToBounds = true
    }
}
