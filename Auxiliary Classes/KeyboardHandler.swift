import UIKit

class KeyboardHandler: NSObject {
  weak var tableView: UITableView!
  weak var view: UIView!

  static func new(tableView: UITableView, view: UIView) -> KeyboardHandler {
    let kh = KeyboardHandler()
    kh.tableView = tableView
    kh.view = view
    NotificationCenter.default.addObserver(
      kh,
      selector: #selector(KeyboardHandler.keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      kh,
      selector: #selector(KeyboardHandler.keyboardDidShow(_:)),
      name: UIResponder.keyboardDidShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      kh,
      selector: #selector(KeyboardHandler.keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
    return kh
  }

  var defaultInsets: UIEdgeInsets!
  var keyboardHeight: CGFloat!

  @objc func keyboardWillShow(_ notification: Notification) {
    if let userInfo = notification.userInfo {

      if defaultInsets == nil {
        defaultInsets = tableView.contentInset
      }

      let value =
        (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject)
        .cgRectValue
      keyboardHeight =
        value?.height ?? view.frame.height
        * CGFloat(
          Lets.keyboardToViewRatio
        )

      let insets = UIEdgeInsets(
        top: defaultInsets.top,
        left: defaultInsets.left,
        bottom: keyboardHeight,
        right: defaultInsets.right
      )

      tableView.contentInset = insets
      tableView.scrollIndicatorInsets = insets
    }
  }

  @objc func keyboardDidShow(_ notification: Notification) {
    scrollToTextField()
  }

  func scrollToTextField() {
    if let firstResponder = UIResponder.currentFirstResponder as? UIView {

      let frFrame = firstResponder.frame

      let corrected = UIApplication.shared.keyWindow!.convert(
        frFrame,
        from: firstResponder.superview
      )
      let yRelativeToKeyboard =
        (view.frame.height - keyboardHeight)
        - (corrected.origin.y + corrected.height)

      if yRelativeToKeyboard < 0 {

        let frInViewsFrame = view.convert(
          frFrame,
          from: firstResponder.superview
        )
        let scrollPoint = CGPoint(
          x: 0,
          y: frInViewsFrame.origin.y - keyboardHeight
            - tableView.contentInset
            .top
            - frInViewsFrame
            .height - UIApplication.shared.statusBarFrame.height
        )

        tableView.setContentOffset(scrollPoint, animated: true)
      }
    }
  }

  @objc func keyboardWillHide(_ notification: Notification) {
    UIView.animate(withDuration: 0.2) {
      guard let defaultInsets = self.defaultInsets else { return }
      self.tableView.contentInset = defaultInsets
      self.tableView.scrollIndicatorInsets = defaultInsets
      self.defaultInsets = nil
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
