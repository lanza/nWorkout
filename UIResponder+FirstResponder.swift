import UIKit

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder?
    public class func currentFirstResponder() -> UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder), to: nil, from: nil, for: nil)
        return UIResponder._currentFirstResponder
    }
    
    internal func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}
