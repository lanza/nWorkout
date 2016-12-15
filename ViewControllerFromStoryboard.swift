import UIKit

protocol ViewControllerFromStoryboard {
    static func new() -> Self
}
extension ViewControllerFromStoryboard {
    static func new() -> Self {
        return UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }
}

