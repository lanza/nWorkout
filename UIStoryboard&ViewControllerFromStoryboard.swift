import UIKit

protocol ViewControllerFromStoryboard {
    static func new() -> Self
}
extension ViewControllerFromStoryboard {
    static func new() -> Self {
        return UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }
}

extension UIStoryboard {
    static var main: UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }
}

