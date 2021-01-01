import UIKit

class CompleteButton: UIButton {
  init() {
    super.init(frame: CGRect.zero)
    setTitle(Lets.done)

    titleLabel?.numberOfLines = 1
    titleLabel?.minimumScaleFactor = 5 / titleLabel!.font.pointSize
    titleLabel?.adjustsFontSizeToFitWidth = true

  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  func setComplete(_ bool: Bool) {
    setTitleColor(
      bool
        ? #colorLiteral(
          red: 0.1764705926, green: 0.4980392158,
          blue: 0.7568627596, alpha: 1)
        : #colorLiteral(
          red: 0.8039215803, green: 0.8039215803,
          blue: 0.8039215803, alpha: 1)
    )
  }

  func setHide(_ bool: Bool) {
    isHidden = bool
  }
}
