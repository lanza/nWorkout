import UIKit

class LiftTableHeaderLabelHolder: UIView {
  let lthl = LiftTableHeaderLabel.create()

  static func create(text: String) -> LiftTableHeaderLabelHolder {
    let l = LiftTableHeaderLabelHolder()

    if text == "Combined" {
      l.lthl.text = "Status"
    } else {
      l.lthl.text = text
    }

    l.lthl.translatesAutoresizingMaskIntoConstraints = false
    l.addSubview(l.lthl)

    return l
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    lthl.frame = CGRect(
      x: 1,
      y: 0,
      width: frame.width - 2,
      height: frame.height
    )
  }
}
