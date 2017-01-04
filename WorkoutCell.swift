import UIKit
import ChartView
import RxSwift
import RxCocoa

extension WorkoutCell: ConfigurableCell {
    func configure(for object: Workout, at indexPath: IndexPath) {
        
        chartView.chartViewDataSource = BaseChartViewDataSource(object: object)
        
        label.text = Lets.workoutDateDF.string(from: object.startDate)
        
        chartView.configurationClosure = { (index,rowView) in
            let lift = object.object(at: index)
            (rowView.columnViews[0] as! UILabel).text = lift.name
            (rowView.columnViews[0] as! UILabel).textAlignment = .center
            (rowView.columnViews[1] as! UILabel).text = String(lift.sets.count) + " sets"
            (rowView.columnViews[1] as! UILabel).textAlignment = .center
        }
        
        chartView.setup()
        setNeedsUpdateConstraints()
    }
}

class WorkoutCell: ChartViewCell {
    
    let label = UILabel()
    
    func setupTopContentView() {
        label.translatesAutoresizingMaskIntoConstraints = false
        topContentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topContentView.topAnchor),
            label.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
            label.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor)
            ])
    }
    func setupBottomContentView() {    }
    func setupChartView() {}
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTopContentView()
        setupBottomContentView()
        setupChartView()
        
        backgroundColor = Theme.Colors.light
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}











