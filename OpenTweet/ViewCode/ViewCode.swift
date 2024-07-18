import UIKit

protocol ViewCode: UIView {
    func setupViewCode()
    func buildHierarchy()
    func buildConstraints()
    func additionalConfiguration()
}

extension ViewCode {
    func buildHierarchy() {
        assertionFailure("method needs to be redeclared")
    }

    func buildConstraints() {
        assertionFailure("method needs to be redeclared")
    }

    func additionalConfiguration() {
        /// optional method
    }
}

struct ViewCodeConstants {
    static let sidePaddings: CGFloat = 24.0
    static let verticalPaddings: CGFloat = 8.0
    static let insidePadding: CGFloat = 8.0
    static let avatarHeightWidth: CGFloat = 40.0
    static let avatarCornerRadius: CGFloat = 20.0
    static let fontSize: CGFloat = 14.0
}
