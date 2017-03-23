import UIKit
import ChartView

class LiftTableHeaderView: UIView {
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var liftTableHeaderRowView: LiftTableHeaderRowView!
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .darkGray
        setRV()
        setupViews()
        setNeedsLayout()
    }
    func setRV() {
        liftTableHeaderRowView = LiftTableHeaderRowView()
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
    required init?(coder aDecoder: NSCoder) { fatalError() }
    required init() {
        super.init()
        backgroundColor = Theme.Colors.dark
        columnBackgroundColor = Theme.Colors.darkest
        setupViews()
    }
    
    let viewInfos = ViewInfo.saved.filter { $0.isOn }
    
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
        
        
        return l
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lthl.frame = CGRect(x: 1, y: 0, width: frame.width - 2, height: frame.height)
    }
}

class LiftTableHeaderLabel: UILabel {
    static func create() -> LiftTableHeaderLabel {
        let l = LiftTableHeaderLabel()
        
        l.setContentCompressionResistancePriority(0, for: .horizontal)
        l.setContentCompressionResistancePriority(0, for: .vertical)
        l.setContentHuggingPriority(0, for: .horizontal)
        l.setContentHuggingPriority(0, for: .vertical)
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.numberOfLines = 0
        l.baselineAdjustment = .alignCenters
        
        l.textColor = .white
        l.backgroundColor = .clear
        
        l.setFontScaling(minimum: 1)
        
        return l
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

class StatisticsHistoryTableHeaderView: LiftTableHeaderView {
    override func setRV() {
        liftTableHeaderRowView = StatisticsHistoryTableHeaderRowView()
    }
}
class StatisticsHistoryTableHeaderRowView: LiftTableHeaderRowView {
    override func setupViews() {
        let i = ViewInfo.statisticsHistoryColumnViewInfo
        order = i.map { $0.0 }
        columnWidths = i.map { $0.1 }
        columnViewTypes = i.map { _ in UILabel.self }
        
        setupColumns()
    }
}




