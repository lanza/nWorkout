import UIKit

public extension UIButton {
  func setTitle(_ title: String) {
    setTitle(title, for: UIControl.State())
  }
  func setTitleColor(_ color: UIColor) {
    setTitleColor(color, for: UIControl.State())
  }

}
