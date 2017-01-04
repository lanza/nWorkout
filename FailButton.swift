import UIKit

class FailButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        setTitle(Lets.failButtonText, for: UIControlState())
        setTitleColor(.black, for: UIControlState())
        
        titleLabel?.numberOfLines = 1
        titleLabel?.minimumScaleFactor = 3/titleLabel!.font.pointSize
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
