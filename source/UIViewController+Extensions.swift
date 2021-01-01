import UIKit

extension UIViewController {
  public func presentAlert(
    title: String,
    message: String? = nil,
    okText: String,
    cancelText: String? = nil,
    okHandler: ((UIAlertAction) -> Void)? = nil,
    cancelHandler: ((UIAlertAction) -> Void)? = nil,
    textFieldConfigurationHandler: ((UITextField) -> Void)? = nil,
    completion: (() -> Void)? = nil
  ) {
    let av = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    let ok = UIAlertAction(title: okText, style: .default, handler: okHandler)
    av.addAction(ok)
    if let cancel = cancelText {
      let cancel = UIAlertAction(
        title: cancel,
        style: .cancel,
        handler: cancelHandler
      )
      av.addAction(cancel)
    }
    if let tfch = textFieldConfigurationHandler {
      av.addTextField(configurationHandler: tfch)
    }

    present(av, animated: true, completion: completion)
  }
}
