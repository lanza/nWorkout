import UIKit
import ChartView

class LiftTableHeaderView: RowView {
    
    static func create() -> LiftTableHeaderView {
        let l = LiftTableHeaderView()
        l.setupViews()
        return l
    }
    var viewInfos = ViewInfo.saved
    
    
    var setNumberLabel: UILabel!
    var previousWorkoutLabel: UILabel!
    var targetWeightLabel: UILabel!
    var targetRepsLabel: UILabel!
    var completedWeightLabel: UILabel!
    var completedRepsLabel: UILabel!
    var doneButtonLabel: UILabel!
    var failButtonLabel: UILabel!
    var noteButtonLabel: UILabel!
    var combinedLabel: UILabel!
    
    let dict = [Lets.setNumberKey:"Set",
                Lets.previousWorkoutKey:"Previous",
                Lets.targetWeightKey:"Weight",
                Lets.targetRepsKey:"Reps",
                Lets.completedWeightKey: "Completed Weight",
                Lets.completedRepsKey:"Completed Reps",
                Lets.doneButtonKey:"Status",
                Lets.failButtonKey:"Fail",
                Lets.noteButtonKey:"Note"
    ]
    
    
    var order: [String]!
    
    func setupViews() {
        order = viewInfos.map { $0.name }
        
        for key in order {
            let l = LiftTableHeaderLabel.create(text: dict[key]!)
            addSubview(l)
            l.translatesAutoresizingMaskIntoConstraints = false
            
            
        }
    }
}



class LiftTableHeaderLabel: UILabel {
    static func create(text: String) -> LiftTableHeaderLabel {
        let l = LiftTableHeaderLabel()
        l.text = text
        return l
    }
}
