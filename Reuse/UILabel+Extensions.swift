import UIKit

extension UILabel {
  public func setFontScaling(minimum: CGFloat) {
    minimumScaleFactor = minimum / font.pointSize
    adjustsFontSizeToFitWidth = true
  }
}
