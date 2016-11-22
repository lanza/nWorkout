import UIKit

extension UIButton {
    func setTitle(_ title: String) {
        setTitle(title, for: UIControlState())
    }
    func setTitleColor(_ color: UIColor) {
        setTitleColor(color, for: UIControlState())
    }
}
