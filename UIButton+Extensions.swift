import UIKit

extension UIButton {
    func setTitle(_ title: String) {
        setTitle(title, for: UIControlState())
    }
    func setTitleColor(_ color: UIColor) {
        setTitleColor(color, for: UIControlState())
    }
    
    func setBorder(color: UIColor, width: CGFloat, radius: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.cornerRadius = radius
    }
}
