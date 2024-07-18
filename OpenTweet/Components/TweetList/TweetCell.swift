import UIKit
import Combine

final class TweetCell: UITableViewCell {

    private var cancellable = Set<AnyCancellable>()

    struct CellIdentifier {
        static let name = "tweetCell"
    }

    private lazy var labelAuthorName: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: ViewCodeConstants.fontSize, weight: .bold)
        label.textColor = .black
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
        return label
    }()

    private lazy var imageAvatar: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = ViewCodeConstants.avatarCornerRadius
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()

    func setupWith(viewModel: TweetCellViewModelProtocol) {
        setupViewCode()
        labelAuthorName.text = viewModel.authorName
        labelDate.text = viewModel.dateShortString
        labelContent.attributedText = viewModel.contentAttributedString
        viewModel.loadUserAvatar()?
            .sink(receiveCompletion: { _ in }, receiveValue: { result in
                DispatchQueue.main.async { [weak self] in
                    self?.imageAvatar.contentMode = .scaleAspectFit
                    self?.imageAvatar.alpha = 0.0
                    self?.imageAvatar.image = result.image

                    if result.animated {
                        UIView.animate(withDuration: 0.2) {
                            self?.imageAvatar.alpha = 1.0
                        }
                    } else {
                        self?.imageAvatar.alpha = 1.0
                    }
                }
            }).store(in: &cancellable)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        /// Here we are checking to see if the cell which is already selected, was selected (touched) again, so we can dismiss the selection state
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
