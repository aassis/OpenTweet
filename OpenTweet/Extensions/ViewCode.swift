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
        // optional
    }
}
