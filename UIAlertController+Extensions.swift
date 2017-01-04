import UIKit

extension UIAlertController {
    static func alert(title: String, message: String?) -> UIAlertController {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addTextField { tf in
            tf.keyboardAppearance = .dark
            tf.returnKeyType = .done
        }
        return a
    }
}
