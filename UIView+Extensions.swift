import UIKit

extension UIView {
    func setBorder(color: UIColor, width: CGFloat, radius: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.cornerRadius = radius
    }
}
