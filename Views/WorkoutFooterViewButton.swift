import UIKit

class WorkoutFooterViewButton: UIButton {
    enum WorkoutFooterViewButtonType {
        case addLift
        case cancel
        case finish
        case details
    }
    static func create(title: String, type: WorkoutFooterViewButtonType) -> WorkoutFooterViewButton {
        let b = WorkoutFooterViewButton()
        b.setTitle(title)
        b.backgroundColor = Theme.Colors.dark
        
        
        b.setTitleColor(.white)
//        switch type {
//        case .addLift: b.setTitleColor(Theme.Colors.main)
//        case .cancel: b.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
//        case .finish: b.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
//        case .details: b.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
//        }
        
        b.setBorder(color: .black, width: 1, radius: 4)
        return b
    }
}
