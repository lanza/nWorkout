import UIKit

extension UIBarButtonItem {
  public convenience init(title: String, style: UIBarButtonItem.Style) {
    self.init(title: title, style: style, target: nil, action: nil)
  }
}
