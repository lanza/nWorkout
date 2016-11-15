import UIKit
import ChartView
import RxSwift
import RxCocoa

class LiftCell: ChartViewCell {
    
    var rowViews: [SetRowView] { return chartView.rowViews as! [SetRowView] }
    
    var setNumberLables: [UILabel?] { return rowViews.map { $0.setNumberLabel } }
    var weightTextFields: [UITextField?] { return rowViews.map { $0.targetWeightTextField } }
    var repsTextFields: [UITextField?] { return rowViews.map { $0.targetRepsTextField } }
    
    let label = UILabel()
    let addSetButton = UIButton(type: .roundedRect)
    
    func setupTopContentView() {
        label.text = "Hi muffin"
        label.translatesAutoresizingMaskIntoConstraints = false
        topContentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topContentView.topAnchor),
            label.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
            label.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor)
            ])
    }
    func setupBottomContentView() {
        addSetButton.setTitle("Add Set...", for: UIControlState())
        addSetButton.translatesAutoresizingMaskIntoConstraints = false
        bottomContentView.addSubview(addSetButton)
        
        NSLayoutConstraint.activate([
            addSetButton.leftAnchor.constraint(equalTo: bottomContentView.leftAnchor),
            addSetButton.rightAnchor.constraint(equalTo: bottomContentView.rightAnchor),
            addSetButton.topAnchor.constraint(equalTo: bottomContentView.topAnchor),
            addSetButton.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor)
            ])
    }
    func setupChartView() {
        chartView.register(SetRowView.self, forResuseIdentifier: "row")
        chartView.chartViewDataSource = ChartViewConfigurator(rowHeight: 31, numberOfRows: 0, rowSpacing: 2, backgroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTopContentView()
        setupBottomContentView()
        setupChartView()
        
        
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
        
        chartView.configurationClosure = { (index,rowView) in
            let rowView = rowView as! SetRowView
            let set = object.object(at: index)
            
            if let snl = rowView.setNumberLabel {
                snl.text = String(index)
            }
            if let twtf = rowView.targetWeightTextField {
                twtf.text = String(set.weight)
            }
            if let trtf = rowView.targetRepsTextField {
                trtf.text = String(set.reps)
            }
            if let cwtf = rowView.completedWeightTextField {
                cwtf.text = String(set.completedWeight)
            }
            if let crtf = rowView.completedRepsTextField {
                crtf.text = String(set.completedReps)
            }
        }
        
        chartView.setup()
        setNeedsUpdateConstraints()
    }
}
