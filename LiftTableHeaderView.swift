import UIKit
import ChartView

class LiftTableHeaderView: RowView {
    
    static func create() -> LiftTableHeaderView {
        let l = LiftTableHeaderView()
        l.setupViews()
        return l
    }
    var viewInfos = ViewInfo.saved
  
    override func getColumnView(columnNumber: Int) -> UIView {
        let text = dict[order[columnNumber]]!
        return LiftTableHeaderLabel.create(text: text)
    }
    
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
        columnWidths = viewInfos.map { $0.width }
        
        setupColumns()
    }
}



class LiftTableHeaderLabel: UILabel {
    static func create(text: String) -> LiftTableHeaderLabel {
        let l = LiftTableHeaderLabel()
        l.text = text
        return l
    }
}
