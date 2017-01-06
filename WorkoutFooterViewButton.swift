import UIKit

class WorkoutFooterViewButton: UIButton {
    enum WorkoutFooterViewButtonType {
        case addLift
        case cancel
        case finish
    }
    static func create(title: String, type: WorkoutFooterViewButtonType) -> WorkoutFooterViewButton {
        let b = WorkoutFooterViewButton()
        b.setTitle(title)
        b.backgroundColor = #colorLiteral(red: 0.9419541359, green: 0.9359999299, blue: 0.9465249181, alpha: 1)
        
        switch type {
        case .addLift: b.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
        case .cancel: b.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
        case .finish: b.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
        }
        
        b.setBorder(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), width: 2, radius: 4)
        return b
    }
}
