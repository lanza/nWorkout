import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: UILayoutConstraintAxis, spacing: CGFloat, distribution: UIStackViewDistribution) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
    }
    convenience init(axis: UILayoutConstraintAxis, spacing: CGFloat, distribution: UIStackViewDistribution) {
        self.init(arrangedSubviews: [], axis: axis, spacing: spacing, distribution: distribution)
    }
}
