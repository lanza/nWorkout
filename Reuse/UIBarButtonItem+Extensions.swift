import UIKit

public extension UIBarButtonItem {
  convenience init(title: String, style: UIBarButtonItem.Style) {
    self.init(title: title, style: style, target: nil, action: nil)
  }
}
