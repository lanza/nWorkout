import UIKit

extension UITextField {
    func setFontScaling(minimum: CGFloat) {
        minimumFontSize = minimum
        adjustsFontSizeToFitWidth = true
    }
}
