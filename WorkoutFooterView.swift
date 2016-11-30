import UIKit

class WorkoutFooterView: UIView {
    @IBOutlet weak var addLiftButton: UIButton!
    @IBOutlet weak var cancelWorkoutButton: UIButton!
    @IBOutlet weak var finishWorkoutButton: UIButton!
    
    static func fromNib() -> WorkoutFooterView {
        guard let view = Bundle.main.loadNibNamed("WorkoutFooterView", owner: self, options: nil)?[0] as? WorkoutFooterView else { fatalError() }
        return view
    }
}
