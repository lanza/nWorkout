import UIKit

class WeightAndRepsTextField: UITextField {
    init() {
        super.init(frame: CGRect.zero)
        textAlignment = .center
        inputView = Keyboard.shared
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
