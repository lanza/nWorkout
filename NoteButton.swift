import UIKit

class NoteButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        setTitle(Lets.abbreviatedNoteButtonText)
        
        titleLabel?.numberOfLines = 1
        titleLabel?.minimumScaleFactor = 3/titleLabel!.font.pointSize
        titleLabel?.adjustsFontSizeToFitWidth = true
        
                textColor = .white
    }
    func update<Type: Base>(for base: Type) {
        setTitleColor(base.note.characters.count > 0 ? #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
}
