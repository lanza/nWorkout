import UIKit

extension UIButton {
  public func setTitle(_ title: String) {
    setTitle(title, for: UIControl.State())
  }
  public func setTitleColor(_ color: UIColor) {
    setTitleColor(color, for: UIControl.State())
  }

}
