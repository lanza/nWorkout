import UIKit

class FailButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
      setTitle(Lets.failButtonText, for: UIControl.State())
        
        titleLabel?.numberOfLines = 1
        titleLabel?.minimumScaleFactor = 3/titleLabel!.font.pointSize
        titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func setFail(_ bool: Bool) {
        setTitleColor(bool ? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
}
