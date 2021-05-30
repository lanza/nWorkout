import UIKit

class FailButton: UIButton {
  init() {
    super.init(frame: CGRect.zero)
    setTitle(Lets.failButtonText, for: UIControl.State())

    titleLabel?.numberOfLines = 1
    titleLabel?.minimumScaleFactor = 3 / titleLabel!.font.pointSize
    titleLabel?.adjustsFontSizeToFitWidth = true

  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  func setFail(_ bool: Bool) {
    setTitleColor(
      bool
        ? .red
        : .black
    )
  }
}
