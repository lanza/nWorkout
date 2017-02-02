import UIKit
import ChartView

class LiftTableHeaderView: UIView {
   
    var liftTableHeaderRowView: LiftTableHeaderRowView!
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .darkGray
        setRV()
        setupViews()
    }
    
    func setRV() {
        liftTableHeaderRowView = LiftTableHeaderRowView()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
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

class RoutineLiftTableHeaderView: LiftTableHeaderView {
    override func setRV() {
        liftTableHeaderRowView = RoutineLiftTableHeaderRowView()
    }
}

class RoutineLiftTableHeaderRowView: LiftTableHeaderRowView {
    override func setupViews() {
        let i = ViewInfo.routineColumnViewInfo
        order = i.map { $0.0 }
        columnWidths = i.map { $0.1 }
        columnViewTypes = i.map { _ in UILabel.self }
        
        setupColumns()
    }
    
}


class LiftTableHeaderRowView: RowView {
    
    required init() {
        super.init()
        
        backgroundColor = Theme.Colors.dark
        
        columnBackgroundColor = Theme.Colors.darkest
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewInfos = ViewInfo.saved
  
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
        order = viewInfos.map { $0.name }
        columnWidths = viewInfos.map { $0.width }
        columnViewTypes = viewInfos.map { _ in UILabel.self }
        
        setupColumns()
    }
}

class LiftTableHeaderLabelHolder: UIView {
    let lthl = LiftTableHeaderLabel.create()
    static func create(text: String) -> LiftTableHeaderLabelHolder {
        let l = LiftTableHeaderLabelHolder()
        l.lthl.text = text
        
        
        l.lthl.translatesAutoresizingMaskIntoConstraints = false
        l.addSubview(l.lthl)
        
        NSLayoutConstraint.activate([
            l.lthl.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 1),
            l.lthl.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -1),
            l.lthl.topAnchor.constraint(equalTo: l.topAnchor),
            l.lthl.bottomAnchor.constraint(equalTo: l.bottomAnchor)
            ])
        return l
    }
}

class LiftTableHeaderLabel: UILabel {
    static func create() -> LiftTableHeaderLabel {
        let l = LiftTableHeaderLabel()
        
        l.textAlignment = .center
        l.numberOfLines = 0
        l.baselineAdjustment = .alignCenters
        
        l.textColor = .white
        l.backgroundColor = .clear
        
        l.setFontScaling(minimum: 1)
        
        return l
    }
}
