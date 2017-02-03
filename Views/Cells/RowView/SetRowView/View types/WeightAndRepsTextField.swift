import UIKit
import Reuse
import BonMot

class WeightAndRepsTextField: UITextField {
    init() {
        super.init(frame: CGRect.zero)
        textAlignment = .center
        inputView = Keyboard.shared
        
        textColor = .white

        setFontScaling(minimum: 6)
    }
    
    override var placeholder: String? {
        didSet {
            let s = StringStyle(.color(.gray))
            attributedPlaceholder = placeholder?.styled(with: s)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func setNumber(double: Double) {
        if double.remainder(dividingBy: 1) == 0 {
            setNumber(int: Int(double))
        } else {
            setNumberString("\(double)")
        }
    }
    func setNumber(int: Int) {
        setNumberString("\(int)")
    }
    private func setNumberString(_ string: String) {
        text = string
    }
}
