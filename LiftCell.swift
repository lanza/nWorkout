import UIKit
import ChartView
import RxSwift
import RxCocoa

class WorkoutLiftCell: LiftCell {
    override func setupChartView() {
        super.setupChartView()
        chartView.register(SetRowView.self, forResuseIdentifier: "row")
    }
}

class RoutineLiftCell: LiftCell {
    override func setupChartView() {
        super.setupChartView()
        chartView.register(RoutineSetRowView.self, forResuseIdentifier: "row")
    }
    
    override func configure(for object: Lift, at indexPath: IndexPath) {
        super.configure(for: object, at: indexPath)
    }
}

extension LiftCell: ChartViewDelegate {
    func chartView(_ chartView: ChartView, commit editingStyle: ChartView.EditingStyle, forRowAt index: Int) {
        RLM.write {
            let set = lift.sets[index]
            lift.sets.remove(objectAtIndex: index)
            RLM.realm.delete(set)
        }
    }
}

class LiftCell: ChartViewCell {
    
    weak var lift: Lift!
    
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
        addSetButton.layer.borderColor = UIColor.darkGray.cgColor
        addSetButton.layer.borderWidth = 3
        addSetButton.backgroundColor = .white
        
        bottomContentView.addSubview(addSetButton)
        
        NSLayoutConstraint.activate([
            addSetButton.leftAnchor.constraint(equalTo: bottomContentView.leftAnchor),
            addSetButton.rightAnchor.constraint(equalTo: bottomContentView.rightAnchor),
            addSetButton.topAnchor.constraint(equalTo: bottomContentView.topAnchor),
            addSetButton.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor)
            ])
    }
    func setupChartView() {
        chartView.delegate = self
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTopContentView()
        setupBottomContentView()
        setupChartView()
        
        backgroundColor = Theme.Colors.light
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
            rowView.set = set
            
            if let snl = rowView.setNumberLabel {
                snl.text = String(index + 1)
            }
            if let twtf = rowView.targetWeightTextField {
                var weight: String
                if set.weight.remainder(dividingBy: 1) == 0 {
                    weight = String(Int(set.weight))
                } else {
                    weight = String(set.weight)
                }
                twtf.text = weight
            }
            if let trtf = rowView.targetRepsTextField {
                trtf.text = String(set.reps)
            }
            if let cwtf = rowView.completedWeightTextField {
                var weight: String
                if set.completedWeight.remainder(dividingBy: 1) == 0 {
                    weight = String(Int(set.completedWeight))
                } else {
                    weight = String(set.completedWeight)
                }
                cwtf.text = weight
            }
            if let crtf = rowView.completedRepsTextField {
                crtf.text = String(set.completedReps)
            }
            if let pl = rowView.previousLabel {
                if object.previousStrings.count > index && object.previousStrings[0] != "" {
                    pl.text = object.previousStrings[index]
                } else {
                    pl.text = "No previous set"
                }
            }
            
            if let cb = rowView.completeButton {
                if set.weight == set.completedWeight, set.reps == set.completedReps {
                    cb.setTitle("Done")
                }
            }
            
            if set.completedReps > 0 && set.completedReps < set.reps, set.completedWeight > 0, let fb = rowView.failButton {
                fb.setTitleColor(.red)
            }
            
            if let cv = rowView.combinedView {
                if set.weight == set.completedWeight && set.reps == set.completedReps {
                    cv.completeButton.isHidden = false
                    cv.completedWeightTextField.isHidden = true
                    cv.completedRepsTextField.isHidden = true
                } else if set.completedWeight == 0 && set.completedReps == 0 {
                    cv.completeButton.isHidden = false
                    cv.completedWeightTextField.isHidden = true
                    cv.completedRepsTextField.isHidden = true
                } else {
                    cv.completeButton.isHidden = true
                    cv.completedWeightTextField.isHidden = false
                    cv.completedRepsTextField.isHidden = false
                }
            }
        }
        
        chartView.setup()
        setNeedsUpdateConstraints()
    }
}
