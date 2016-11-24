import UIKit
import ChartView
import RxSwift
import RxCocoa

class RoutineSetRowView: SetRowView {
    override func setupSelectedColumnViewTypesAndWidth() {
        selectedColumnViewTypes = ["SetNumber","TargetWeight","TargetReps"]
        selectedColumnViewWidths = [10,45,45]
    }
}

class WeightAndRepsTextField: UITextField {
    init() {
        super.init(frame: CGRect.zero)
        textAlignment = .center
        inputView = Keyboard.shared
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

class CompletedWeightAndRepsTextField: WeightAndRepsTextField {
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

class SetNumberLabel: UILabel {
    init() {
        super.init(frame: CGRect.zero)
        textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

class WeightAndRepsLabel: UILabel {
    init() {
        super.init(frame: CGRect.zero)
        textAlignment = .center
        
        textColor = .lightGray
        
        minimumScaleFactor = 7/font.pointSize
        adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

class FailButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        setTitle("F", for: UIControlState())
        setTitleColor(.black, for: UIControlState())
        
        titleLabel?.numberOfLines = 1
        titleLabel?.minimumScaleFactor = 5/titleLabel!.font.pointSize
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
class CompleteButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        setTitle("", for: UIControlState())
        setTitleColor(.red, for: UIControlState())
        
        titleLabel?.numberOfLines = 1
        titleLabel?.minimumScaleFactor = 5/titleLabel!.font.pointSize
        titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

class SetRowView: RowView {
    override func prepareForReuse() {
        super.prepareForReuse()
        set = nil
    }
    override func setupColumns() {
        super.setupColumns()
        db = DisposeBag()
        setupButtons()
    }
    
    var set: (nWorkout.Set)!
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    required init() {
        super.init()
        
        setupSelectedColumnViewTypesAndWidth()
        configColumnViewTypes()
        configColumnWidthPercentages()
        configOtherSettings()
    }
    let viewInfos = (UserDefaults.standard.value(forKey: Lets.viewInfoKey) as? [[Any]]).map { $0.map { ViewInfo.from(array: $0) } } ?? ViewInfo.all
    var selectedColumnViewTypes: [String]!
    var selectedColumnViewWidths: [CGFloat]!
    func configColumnViewTypes() {
        columnViewTypes = selectedColumnViewTypes.map { dict[$0]! }
    }
    func configColumnWidthPercentages() {
        let sum = selectedColumnViewWidths.reduce(0, +)
        columnWidthPercentages = selectedColumnViewWidths.map { ($0 * 100) / sum }
    }
    func setupSelectedColumnViewTypesAndWidth() {
        selectedColumnViewTypes = viewInfos.filter { $0.isOn }.map { $0.name }
        selectedColumnViewWidths = viewInfos.filter { $0.isOn }.map { $0.width }
    }
    func configOtherSettings() {
        usesCombinedView = UserDefaults.standard.value(forKey: Lets.combineFailAndCompletedWeightAndRepsKey) as? Bool ?? false
    }
    var usesCombinedView = false
    var didFail = false {
        didSet {
            failButton?.setTitleColor(didFail ? .red : .black)
            completeButton?.setTitle("")
            if combinedView != nil {
                completeButton?.isHidden = didFail
                completedWeightTextField?.isHidden = !didFail
                completedRepsTextField?.isHidden = !didFail
            }
        }
    }
    var isComplete = false {
        didSet {
            completeButton?.setTitle(isComplete ? "Done" : "")
            didFail = false
            
            if combinedView != nil {
                completedWeightTextField?.isHidden = true
                completedRepsTextField?.isHidden = true
            }
            
            RLM.write {
                set.completedWeight = isComplete ? set.weight : 0
                set.completedReps = isComplete ? set.reps : 0
            }
        }
    }
    
    func setupButtons() {
        failButton?.rx.tap.subscribe(onNext: { [unowned self] in
            self.didFail = !self.didFail
        }).addDisposableTo(db)
        completeButton?.rx.tap.subscribe(onNext: { [unowned self] in
            self.isComplete = !self.isComplete
        }).addDisposableTo(db)
    }
    
    let dict: [String:UIView.Type] = [
        Lets.setNumberKey:SetNumberLabel.self,
        Lets.previousWorkoutKey:WeightAndRepsLabel.self,
        Lets.targetWeightKey:WeightAndRepsTextField.self,
        Lets.targetRepsKey:WeightAndRepsTextField.self,
        Lets.completedWeightKey:CompletedWeightAndRepsTextField.self,
        Lets.completedRepsKey:CompletedWeightAndRepsTextField.self,
        "Timer":UILabel.self,
        "Note":UIButton.self,
        Lets.doneButtonKey:CompleteButton.self,
        Lets.failButtonKey:FailButton.self,
        Lets.combineFailAndCompletedWeightAndRepsKey:CombinedView.self
    ]
    
    class CombinedView: UIView {
        
        init() {
            super.init(frame: CGRect.zero)
            backgroundColor = .clear
            isOpaque = false
            
            completedWeightTextField.translatesAutoresizingMaskIntoConstraints = false
            completedRepsTextField.translatesAutoresizingMaskIntoConstraints = false
            completeButton.translatesAutoresizingMaskIntoConstraints = false
            addSubview(completedWeightTextField)
            addSubview(completedRepsTextField)
            addSubview(completeButton)
            
            NSLayoutConstraint.activate([
                completedWeightTextField.leftAnchor.constraint(equalTo: leftAnchor),
                completedWeightTextField.topAnchor.constraint(equalTo: topAnchor),
                completedWeightTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
                completedWeightTextField.rightAnchor.constraint(equalTo: completedRepsTextField.leftAnchor, constant: -5),
                completedRepsTextField.topAnchor.constraint(equalTo: topAnchor),
                completedRepsTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
                completedRepsTextField.rightAnchor.constraint(equalTo: rightAnchor),
                completedWeightTextField.widthAnchor.constraint(equalTo: completedRepsTextField.widthAnchor),
                
                completeButton.leftAnchor.constraint(equalTo: leftAnchor),
                completeButton.topAnchor.constraint(equalTo: topAnchor),
                completeButton.rightAnchor.constraint(equalTo: rightAnchor),
                completeButton.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
        }
        
        let completedWeightTextField = CompletedWeightAndRepsTextField()
        let completedRepsTextField = CompletedWeightAndRepsTextField()
        let completeButton = CompleteButton()
        
        required init?(coder aDecoder: NSCoder) { fatalError() }
    }
    
    var combinedView: CombinedView? {
        guard usesCombinedView else { return nil }
        guard let index = selectedColumnViewTypes.index(of: Lets.combineFailAndCompletedWeightAndRepsKey) else { return nil }
        guard let cv = columnViews[index] as? CombinedView else { fatalError() }
        return cv
    }
    
    var previousLabel: UILabel? {
        guard let index = selectedColumnViewTypes.index(of: Lets.previousWorkoutKey) else { return nil }
        guard let pl = columnViews[index] as? UILabel else { fatalError() }
        return pl
    }
    var setNumberLabel: UILabel? {
        guard let index = selectedColumnViewTypes.index(of: Lets.setNumberKey) else { return nil }
        guard let snl = columnViews[index] as? UILabel else { fatalError() }
        return snl
    }
    var targetWeightTextField: UITextField? {
        guard let index = selectedColumnViewTypes.index(of: Lets.targetWeightKey) else { return nil }
        guard let twtf = columnViews[index] as? UITextField else { fatalError() }
        return twtf
    }
    var targetRepsTextField: UITextField? {
        guard let index = selectedColumnViewTypes.index(of: Lets.targetRepsKey) else { return nil }
        guard let trtf = columnViews[index] as? UITextField else { fatalError() }
        return trtf
    }
    var completedWeightTextField: UITextField? {
        if let cv = combinedView {
            return cv.completedWeightTextField
        }
        guard let index = selectedColumnViewTypes.index(of: Lets.completedWeightKey) else { return nil }
        guard let cwtf = columnViews[index] as? UITextField else { fatalError() }
        return cwtf
    }
    var completedRepsTextField: UITextField? {
        if let cv = combinedView {
            return cv.completedRepsTextField
        }
        guard let index = selectedColumnViewTypes.index(of: Lets.completedRepsKey) else { return nil }
        guard let crtf = columnViews[index] as? UITextField else { fatalError() }
        return crtf
    }
    var completeButton: UIButton? {
        if let cv = combinedView {
            return cv.completeButton
        }
        guard let index = selectedColumnViewTypes.index(of: Lets.doneButtonKey) else { return nil }
        guard let cb = columnViews[index] as? UIButton else { fatalError() }
        return cb
    }
    var failButton: UIButton? {
        guard let index = selectedColumnViewTypes.index(of: Lets.failButtonKey) else { return nil }
        guard let fb = columnViews[index] as? UIButton else { fatalError() }
        return fb
    }
    var db: DisposeBag!
}
