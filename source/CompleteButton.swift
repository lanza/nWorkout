import UIKit

class CompleteButton: UIButton {
  init() {
    super.init(frame: CGRect.zero)
    setTitle(Lets.done)

    titleLabel?.numberOfLines = 1
    titleLabel?.minimumScaleFactor = 5 / titleLabel!.font.pointSize
    titleLabel?.adjustsFontSizeToFitWidth = true

    setTitleColor(.black)
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  func setComplete(_ bool: Bool) {
    setTitleColor(
      bool
        ? .green
        : .black
    )
  }

  func setHide(_ bool: Bool) {
    isHidden = bool
  }
}
