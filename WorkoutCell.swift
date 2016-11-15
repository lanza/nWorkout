import UIKit
import ChartView
import RxSwift
import RxCocoa

extension WorkoutCell: ConfigurableCell {
    static var identifier: String { return "WorkoutCell" }
    func configure(for object: Workout, at indexPath: IndexPath) {
        
        chartView.chartViewDataSource = BaseChartViewDataSource(object: object)
    
        label.text = String(describing: object.startDate)
        
        chartView.configurationClosure = { [unowned object] in
            for (index,(nameOfLiftLabel,setCountLabel)) in self.labels.enumerated() {
                let lift = object.object(at: index)
                nameOfLiftLabel.text = lift.name
                setCountLabel.text = String(lift.sets.count) + " sets"
            }
        }
        
        chartView.setup()
        setNeedsUpdateConstraints()
    }
}

class WorkoutCell: ChartViewCell {
    
    
    var labels: [(UILabel,UILabel)] {
        let firsts = chartView.views(at: 0) as! [UILabel]
        let seconds = chartView.views(at: 1) as! [UILabel]
        return Array(zip(firsts,seconds))
    }
    
    let label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        topContentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topContentView.topAnchor),
            label.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
            label.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor)
        ])
        
        
        
        chartView.chartViewDataSource = ChartViewConfigurator(rowHeight: 31, numberOfRows: 0, rowSpacing: 2, backgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}


class BaseChartViewDataSource<BaseType: DataProvider>: ChartViewDataSource {
    init(object: BaseType) {
        self.object = object
    }
    var object: BaseType
    var numberOfRows: Int { return object.numberOfItems() }
    var rowHeight: CGFloat { return 25 }
    var rowSpacing: CGFloat { return 2 }
    var backgroundColor: UIColor { return .darkGray }
}




class SetRowView: RowView {
    
    var isWorkout = false
    
    var selectedColumnViewTypes: [String]!
    var selectedColumnViewWidths: [CGFloat]!
    
    override var columnViewTypes: [UIView.Type] {
        if isWorkout == false {
            return [UITextField.self,UITextField.self]
        }
        selectedColumnViewTypes = UserDefaults.standard.value(forKey: "selectedColumnViewTypes") as? [String] ?? ["SetNumber","TargetWeight","TargetReps"]
        
        return selectedColumnViewTypes.map { dict[$0]! }
    }
    override var columnWidthPercentages: [CGFloat] {
        if isWorkout == false {
            return [50,50]
        }
        selectedColumnViewWidths = UserDefaults.standard.value(forKey: "selectedColumnViewWidths") as? [CGFloat] ?? [10,45,45]
        let sum = selectedColumnViewWidths.reduce(0, +)
        return selectedColumnViewWidths.map { ($0 * 100) / sum }
    }
    
    let dict: [String:UIView.Type] = [
        "SetNumber":UILabel.self, "PreviousWeight":UILabel.self,
        "PreviousReps":UILabel.self, "TargetWeight":UITextField.self,
        "TargetReps":UITextField.self, "FailureWeight":UITextField.self,
        "FailureReps":UITextField.self, "Timer":UILabel.self,
        "Note":UIButton.self
    ]
    var setNumberLabel: UILabel? {
        guard let index = selectedColumnViewTypes.index(of: "SetNumber") else { return nil }
        guard let setNumberLabel = columnViews[index] as? UILabel else { fatalError() }
        return setNumberLabel
    }
}



