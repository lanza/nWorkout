import UIKit
import ChartView
import RxSwift
import RxCocoa

class LiftCell: ChartViewCell {
    
    var weightTextFields: [UITextField] { return chartView.views(at: 0) as! [UITextField] }
    var repsTextFields: [UITextField] { return chartView.views(at: 1) as! [UITextField] }
    
    let label = UILabel()
    let addSetButton = UIButton(type: .roundedRect)
    
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
        
        addSetButton.setTitle("Add Set...", for: UIControlState())
        addSetButton.translatesAutoresizingMaskIntoConstraints = false
        bottomContentView.addSubview(addSetButton)
        
        NSLayoutConstraint.activate([
            addSetButton.leftAnchor.constraint(equalTo: bottomContentView.leftAnchor),
            addSetButton.rightAnchor.constraint(equalTo: bottomContentView.rightAnchor),
            addSetButton.topAnchor.constraint(equalTo: bottomContentView.topAnchor),
            addSetButton.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor)
            ])
        chartView.register(SetRowView.self, forResuseIdentifier: "row")
        chartView.chartViewDataSource = ChartViewConfigurator(rowHeight: 31, numberOfRows: 0, rowSpacing: 2, backgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        db = DisposeBag()
    }
    
    
    var db = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

extension LiftCell: ConfigurableCell {
    static var identifier: String { return "LiftCell" }
    func configure(for object: Lift, at indexPath: IndexPath) {
        label.text = object.name
        
        chartView.chartViewDataSource = BaseChartViewDataSource(object: object)
        
        chartView.configurationClosure = {
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
