import UIKit
import ChartView

class LiftTableHeaderRowView: RowView {
    required init?(coder aDecoder: NSCoder) { fatalError() }
    required init() { fatalError() }

    enum HeaderType {
        case routine
        case statisticsHistory
        case workout
    }
    
    
    init(type: HeaderType) {
        switch type {
        case .statisticsHistory:
            viewInfo = ViewInfo.statisticsHistoryColumnViewInfo
        case .workout:
            viewInfo = ViewInfo.saved.filter { $0.isOn }.map { ($0.name,$0.width) }
        case .routine:
            viewInfo = ViewInfo.routineColumnViewInfo
        }
        super.init()
        
        backgroundColor = Theme.Colors.dark
        columnBackgroundColor = Theme.Colors.darkest
        setupViews()
    } 
    
    let viewInfo: [(String,CGFloat)]
    
    override func getColumnView(columnNumber: Int) -> UIView {
        let text = dict[order[columnNumber]]!
        return LiftTableHeaderLabelHolder.create(text: text)
    }
    
    let dict = [Lets.setNumberKey:"Set",
                Lets.previousWorkoutKey:"Previous",
                Lets.targetWeightKey:"Weight",
                Lets.targetRepsKey:"Reps",
                Lets.completedWeightKey: "Completed Weight",
                Lets.completedRepsKey:"Completed Reps",
                Lets.doneButtonKey:"Status",
                Lets.failButtonKey:"Fail",
                Lets.noteButtonKey:"Note",
                Lets.doneButtonCompletedWeightCompletedRepsKey:"Combined"
    ]
    var order: [String]!
    
    func setupViews() {
        order = viewInfo.map { $0.0 }
        columnWidths = viewInfo.map { $0.1 }
        columnViewTypes = viewInfo.map { _ in UILabel.self }
        
        setupColumns()
    }
}
