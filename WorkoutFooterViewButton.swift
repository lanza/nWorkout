import UIKit

class WorkoutFooterViewButton: UIButton {
    static func create(title: String) -> WorkoutFooterViewButton {
        let b = WorkoutFooterViewButton()
        b.setTitleColor(.black)
        b.setTitle(title)
        
        b.layer.borderColor = .blue
        b.layer.borderWidth = 5
        b.layer.cornerRadius = 5
        
        return b
    }
}
