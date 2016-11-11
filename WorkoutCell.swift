import UIKit
import ChartView

extension WorkoutCell: ConfigurableCell {
    static var identifier: String { return "ConfigurableCell" }
    func configure(for object: Workout, at indexPath: IndexPath) {
        chartView.numberOfRows = 4
        chartView.columnWidthPercentages = [50,50]
        chartView.columnTypes = [UILabel.self, UILabel.self]
    }
}

class WorkoutCell: ChartViewCell {
    
    var labels: [UILabel] { return chartView.rowViews.map { $0.columnViews[0] as! UILabel } }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let label = UILabel()
        label.text = "Hi Muffin"
        label.translatesAutoresizingMaskIntoConstraints = false
        topContentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topContentView.topAnchor),
            label.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
            label.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor)
        ])
        
        chartView.chartViewDataSource = ChartViewDataSource(rowHeight: 31, numberOfRows: 0, columnWidthPercentages: [100], columnTypes: [UILabel.self], columnViews: nil, columnSpacing: 2, rowSpacing: 2, columnBackgroundColor: .white, rowBackgroundColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), backgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

class LiftCell: ChartViewCell {
    
    var weightTextFields: [UITextField] { return chartView.rowViews.map { $0.columnViews[0] as! UITextField } }
    var repsTextFields: [UITextField] { return chartView.rowViews.map { $0.columnViews[1] as! UITextField } }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let label = UILabel()
        label.text = "Hi Muffin!"
        label.translatesAutoresizingMaskIntoConstraints = false
        topContentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topContentView.topAnchor),
            label.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
            label.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor)
        ])
        
        chartView.chartViewDataSource = ChartViewDataSource(rowHeight: 31, numberOfRows: 0, columnWidthPercentages: [50,50], columnTypes: [UITextField.self,UITextField.self], columnViews: nil, columnSpacing: 2, rowSpacing: 2, columnBackgroundColor: .white, rowBackgroundColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), backgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
