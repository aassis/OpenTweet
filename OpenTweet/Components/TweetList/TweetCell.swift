import UIKit

final class TweetCell: UITableViewCell {
    struct CellIdentifier {
        static let name = "tweetCell"
    }

    struct Constants {
        static let sidePaddings: CGFloat = 24.0
        static let verticalPaddings: CGFloat = 8.0
        static let insidePadding: CGFloat = 8.0
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        if isSelected && selected {
            super.setSelected(false, animated: animated)
            resetCell()
        } else {
            super.setSelected(selected, animated: animated)

            if selected {
                transformCell()
            } else {
                resetCell()
            }
        }
    }

    private func transformCell() {
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = 3.0
        }
    }

    private func resetCell() {
        UIView.animate(withDuration: 0.25) {
            self.transform = .identity
            self.layer.shadowOpacity = 0
        }
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
        let sidePaddings = Constants.sidePaddings
        let verticalPadding = Constants.verticalPaddings
        let insidePadding = Constants.insidePadding
        let avatarHeightWidth = Constants.avatarHeightWidth

        imageAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding).isActive = true
        imageAvatar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sidePaddings).isActive = true
        imageAvatar.widthAnchor.constraint(equalToConstant: avatarHeightWidth).isActive = true
        imageAvatar.heightAnchor.constraint(equalToConstant: avatarHeightWidth).isActive = true
        imageAvatar.heightAnchor.constraint(equalToConstant: avatarHeightWidth).isActive = true

        labelAuthorName.topAnchor.constraint(equalTo: imageAvatar.topAnchor).isActive = true
        labelAuthorName.leftAnchor.constraint(equalTo: imageAvatar.rightAnchor, constant: insidePadding).isActive = true

        labelDate.topAnchor.constraint(equalTo: labelAuthorName.topAnchor).isActive = true
        labelDate.leftAnchor.constraint(equalTo: labelAuthorName.rightAnchor, constant: insidePadding).isActive = true
        labelDate.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -sidePaddings).isActive = true

        labelContent.topAnchor.constraint(equalTo: labelAuthorName.bottomAnchor, constant: insidePadding).isActive = true
        labelContent.leftAnchor.constraint(equalTo: labelAuthorName.leftAnchor).isActive = true
        labelContent.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -sidePaddings).isActive = true
        let constraint = labelContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
        constraint.priority = .defaultHigh
        constraint.isActive = true
    }

    func additionalConfiguration() {
        self.clipsToBounds = true
        self.selectionStyle = .none
    }
}
