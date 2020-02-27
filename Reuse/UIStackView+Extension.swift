import UIKit

public extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
    }
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) {
        self.init(arrangedSubviews: [], axis: axis, spacing: spacing, distribution: distribution)
    }
    
    func set(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) {
        while let first = arrangedSubviews.first {
            removeArrangedSubview(first)
        }
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
    }
    func set(axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) {
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
    }
}
