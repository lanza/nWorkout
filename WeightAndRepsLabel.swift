import UIKit

class WeightAndRepsLabel: UILabel {
    init() {
        super.init(frame: CGRect.zero)
        textAlignment = .center
        
        textColor = .lightGray
        
        minimumScaleFactor = 7/font.pointSize
        adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
