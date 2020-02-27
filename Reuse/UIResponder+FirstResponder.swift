import UIKit

public extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder?
    
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        
        UIApplication.shared.sendAction(#selector(findFirstResponder), to: nil, from: nil, for: nil)
        
        return UIResponder._currentFirstResponder
    }
    
  @objc internal func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}

