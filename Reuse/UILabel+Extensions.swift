import UIKit

public extension UILabel {
    func setFontScaling(minimum: CGFloat) {
        minimumScaleFactor = minimum/font.pointSize
        adjustsFontSizeToFitWidth = true
    }
}
