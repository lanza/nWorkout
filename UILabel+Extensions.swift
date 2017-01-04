import UIKit

extension UILabel {
    func setFontScaling(minimum: CGFloat) {
        minimumScaleFactor = minimum/font.pointSize
        adjustsFontSizeToFitWidth = true
    }
}
