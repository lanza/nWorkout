import UIKit

class NoteButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        setTitle(Lets.noteButtonText)
        setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
        
        titleLabel?.numberOfLines = 1
        titleLabel?.minimumScaleFactor = 3/titleLabel!.font.pointSize
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
}
