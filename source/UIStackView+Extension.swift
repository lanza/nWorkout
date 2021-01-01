import UIKit

extension UIStackView {
  public convenience init(
    arrangedSubviews: [UIView],
    axis: NSLayoutConstraint.Axis,
    spacing: CGFloat,
    distribution: UIStackView.Distribution
  ) {
    self.init(arrangedSubviews: arrangedSubviews)
    self.axis = axis
    self.spacing = spacing
    self.distribution = distribution
  }
  public convenience init(
    axis: NSLayoutConstraint.Axis,
    spacing: CGFloat,
    distribution: UIStackView.Distribution
  ) {
    self.init(
      arrangedSubviews: [],
      axis: axis,
      spacing: spacing,
      distribution: distribution
    )
  }

  public func set(
    arrangedSubviews: [UIView],
    axis: NSLayoutConstraint.Axis,
    spacing: CGFloat,
    distribution: UIStackView.Distribution
  ) {
    while let first = arrangedSubviews.first {
      removeArrangedSubview(first)
    }
    self.axis = axis
    self.spacing = spacing
    self.distribution = distribution
  }
  public func set(
    axis: NSLayoutConstraint.Axis,
    spacing: CGFloat,
    distribution: UIStackView.Distribution
  ) {
    self.axis = axis
    self.spacing = spacing
    self.distribution = distribution
  }
}
