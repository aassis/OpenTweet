import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {

    struct CellIdentifier {
        static let name = "tweetCell"
    }

    static let defaultImage = UIImage(systemName: "person")

    // MARK: - Views

    private lazy var labelAuthorName: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: ViewCodeConstants.fontSize, weight: .bold)
        label.textColor = .black
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var labelContent: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: ViewCodeConstants.fontSize)
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        label.textColor = .darkGray
        return label
    }()

    private lazy var labelDate: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: ViewCodeConstants.fontSize)
        label.textColor = .lightGray
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var imageAvatar: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = TweetCell.defaultImage
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = ViewCodeConstants.avatarCornerRadius
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()

    // MARK: - Setup

    func setupWith(viewModel: TweetCellViewModelProtocol) {
        setupViewCode()
        labelAuthorName.text = viewModel.authorName
        labelDate.text = viewModel.dateShortString
        labelContent.attributedText = viewModel.contentAttributedString
        if let img = viewModel.avatarImage {
            imageAvatar.image = img
        } else if let avatarUrlString = viewModel.avatarUrlString,
           let url = URL(string: avatarUrlString) {
            imageAvatar.af.setImage(withURL: url,
                                    placeholderImage: UIImage(systemName: "person"),
                                    imageTransition: .crossDissolve(0.2),
                                    runImageTransitionIfCached: false) { response in
                viewModel.saveAvatarImage(image: response.value)
            }
        }
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        imageAvatar.image = TweetCell.defaultImage
    }
}

// MARK: - ViewCode

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
        let sidePaddings = ViewCodeConstants.sidePaddings
        let verticalPadding = ViewCodeConstants.verticalPaddings
        let insidePadding = ViewCodeConstants.insidePadding
        let avatarHeightWidth = ViewCodeConstants.avatarHeightWidth

        imageAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding).isActive = true
        imageAvatar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sidePaddings).isActive = true
        imageAvatar.widthAnchor.constraint(equalToConstant: avatarHeightWidth).isActive = true
        imageAvatar.heightAnchor.constraint(equalToConstant: avatarHeightWidth).isActive = true
        imageAvatar.heightAnchor.constraint(equalToConstant: avatarHeightWidth).isActive = true

        labelAuthorName.topAnchor.constraint(equalTo: imageAvatar.topAnchor).isActive = true
        labelAuthorName.leftAnchor.constraint(equalTo: imageAvatar.rightAnchor, constant: insidePadding).isActive = true

        labelDate.topAnchor.constraint(equalTo: labelAuthorName.topAnchor).isActive = true
        labelDate.leftAnchor.constraint(greaterThanOrEqualTo: labelAuthorName.rightAnchor, constant: insidePadding).isActive = true
        labelDate.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -sidePaddings).isActive = true

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
