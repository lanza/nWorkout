import UIKit

class CompleteButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        setTitle("", for: UIControlState())
        setTitleColor(.red, for: UIControlState())
        
        titleLabel?.numberOfLines = 1
        titleLabel?.minimumScaleFactor = 5/titleLabel!.font.pointSize
        titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
