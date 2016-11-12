import UIKit
import ChartView

extension WorkoutCell: ConfigurableCell {
    static var identifier: String { return "WorkoutCell" }
    func configure(for object: Workout, at indexPath: IndexPath) {
        chartView.numberOfRows = object.numberOfItems()
    
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
        
        chartView.chartViewDataSource = ChartViewDataSource(rowHeight: 31, numberOfRows: 0, rowSpacing: 2, rowBackgroundColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), backgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

extension LiftCell: ConfigurableCell {
    static var identifier: String { return "LiftCell" }
    func configure(for object: Lift, at indexPath: IndexPath) {
        chartView.numberOfRows = object.numberOfItems()
        label.text = object.name
        
        chartView.configurationClosure = { [unowned object] in
            for (index,(weightTextField,repsTextField)) in zip(self.weightTextFields,self.repsTextFields).enumerated() {
                let set = object.object(at: index)
                weightTextField.text = String(set.weight)
                repsTextField.text = String(set.reps)
            }
        }
        
        chartView.setup()
        setNeedsUpdateConstraints()
    }
}

class LiftCell: ChartViewCell {
    
    var weightTextFields: [UITextField] { return chartView.views(at: 0) as! [UITextField] }
    var repsTextFields: [UITextField] { return chartView.views(at: 1) as! [UITextField] }
    
    let label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.text = "Hi muffin"
        label.translatesAutoresizingMaskIntoConstraints = false
        topContentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topContentView.topAnchor),
            label.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
            label.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor)
        ])
        
        chartView.chartViewDataSource = ChartViewDataSource(rowHeight: 31, numberOfRows: 0, rowSpacing: 2, rowBackgroundColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), backgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
