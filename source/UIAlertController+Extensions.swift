import UIKit

extension UIAlertController {
  static func alert(title: String, message: String?) -> UIAlertController {
    let a = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    a.addTextField { tf in
      tf.returnKeyType = .done
      tf.autocapitalizationType = .words
    }
    return a
  }

  static func confirmAction(
    title: String,
    message: String,
    onConfirm: @escaping (UIAlertAction) -> Void
  ) -> UIAlertController {
    let a = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    a.addAction(
      UIAlertAction(title: Lets.yes, style: .default, handler: onConfirm)
    )
    a.addAction(UIAlertAction(title: Lets.cancel, style: .cancel))
    return a
  }
}
