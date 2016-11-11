import UIKit

protocol ViewControllerFromStoryboard {
    static func new() -> Self
    static var storyboardIdentifier: String { get }
}
extension ViewControllerFromStoryboard {
    static func new() -> Self {
        return UIStoryboard.main.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}

