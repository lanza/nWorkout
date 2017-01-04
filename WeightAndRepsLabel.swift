import UIKit

class WeightAndRepsLabel: UILabel {
    init() {
        super.init(frame: CGRect.zero)
        textAlignment = .center
        
        textColor = .lightGray
        
        setFontScaling(minimum: 7)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
