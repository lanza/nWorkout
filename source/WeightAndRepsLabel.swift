import UIKit

class WeightAndRepsLabelHolder: UIView {
  let warl = WeightAndRepsLabel()

  var text: String? {
    didSet {
      warl.text = text
    }
  }

  init() {
    super.init(frame: .zero)

    warl.translatesAutoresizingMaskIntoConstraints = false
    addSubview(warl)

  }

  override func layoutSubviews() {
    super.layoutSubviews()

    warl.frame = CGRect(
      x: 3,
      y: 0,
      width: frame.width - 6,
      height: frame.height
    )
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}

class WeightAndRepsLabel: UILabel {
  fileprivate init() {
    super.init(frame: CGRect.zero)

    textAlignment = .center
    numberOfLines = 0
    baselineAdjustment = .alignCenters

    textColor = .lightGray

    setFontScaling(minimum: 4)

    setContentHuggingPriority(UILayoutPriority(rawValue: 0), for: .vertical)
    setContentHuggingPriority(UILayoutPriority(rawValue: 0), for: .horizontal)
    setContentCompressionResistancePriority(
      UILayoutPriority(rawValue: 0),
      for: .vertical
    )
    setContentCompressionResistancePriority(
      UILayoutPriority(rawValue: 0),
      for: .horizontal
    )
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}
