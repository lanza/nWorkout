import UIKit
import ChartView

class LiftTableHeaderView: UIView {
   
    let liftTableHeaderRowView = LiftTableHeaderRowView.create()
    
    static func create() -> LiftTableHeaderView {
        let l = LiftTableHeaderView()
        l.backgroundColor = .darkGray
        l.setupViews()
        return l
    }
    
    
    func setupViews() {
        addSubview(liftTableHeaderRowView)
        liftTableHeaderRowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            liftTableHeaderRowView.leftAnchor.constraint(equalTo: leftAnchor, constant: 1),
            liftTableHeaderRowView.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            liftTableHeaderRowView.rightAnchor.constraint(equalTo: rightAnchor, constant: -1),
            liftTableHeaderRowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
            ])
    }
}


class LiftTableHeaderRowView: RowView {
    
    static func create() -> LiftTableHeaderRowView {
        let l = LiftTableHeaderRowView()
        l.backgroundColor = .darkGray
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
                Lets.noteButtonKey:"Note",
                Lets.doneButtonCompletedWeightCompletedRepsKey:"Combined"
    ]
    var order: [String]!
    
    func setupViews() {
        order = viewInfos.map { $0.name }
        columnWidths = viewInfos.map { $0.width }
        columnViewTypes = viewInfos.map { _ in UILabel.self }
        
        setupColumns()
    }
}



class LiftTableHeaderLabel: UILabel {
    static func create(text: String) -> LiftTableHeaderLabel {
        let l = LiftTableHeaderLabel()
        l.text = text
        l.textAlignment = .center
        l.setFontScaling(minimum: 3)
        return l
    }
}