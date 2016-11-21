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
        isHidden = !(UserDefaults.standard.value(forKey: "alwaysShowCompletedTextFields") as? Bool == true)
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
        
        numberOfLines = Int(7/font.pointSize)
        adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

class FailButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        setTitle("F", for: UIControlState())
        setTitleColor(.red, for: UIControlState())
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
class CompleteButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        setTitle("", for: UIControlState())
        setTitleColor(.red, for: UIControlState())
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
    
    var showCompletedTextFields = UserDefaults.standard.value(forKey: "alwaysShowCompletedTextFields") as? Bool == true {
        didSet {
            completedWeightTextField?.isHidden = !showCompletedTextFields
            completedRepsTextField?.isHidden = !showCompletedTextFields
        }
    }
    var set: (nWorkout.Set)!
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    required init() {
        super.init()
        
        setupSelectedColumnViewTypesAndWidth()
        configColumnViewTypes()
        configColumnWidthPercentages()
    }
    
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
        selectedColumnViewTypes = UserDefaults.standard.value(forKey: "selectedColumnViewTypes") as? [String] ?? ["SetNumber","Previous","TargetWeight","TargetReps","CompletedWeight","CompletedReps","CompleteButton", "FailButton"]
        selectedColumnViewWidths = UserDefaults.standard.value(forKey: "selectedColumnViewWidths") as? [CGFloat] ?? [9,30,22,22,22,22,9,9]
    }
    
    var didFail = false {
        didSet {
            completeButton?.isHidden = didFail
            completedRepsTextField?.isHidden = !didFail
            completedWeightTextField?.isHidden = !didFail
        }
    }
    var isComplete = false {
        didSet {
            completeButton?.setTitle(isComplete ? "Done" : "", for: UIControlState())
            didFail = false
            completedWeightTextField?.isHidden = true
            completedRepsTextField?.isHidden = true
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
        "SetNumber":SetNumberLabel.self, "Previous":WeightAndRepsLabel.self,
        "TargetWeight":WeightAndRepsTextField.self, "TargetReps":WeightAndRepsTextField.self,
        "CompletedWeight":CompletedWeightAndRepsTextField.self, "CompletedReps":CompletedWeightAndRepsTextField.self,
        "Timer":UILabel.self, "Note":UIButton.self,
        "CompleteButton":CompleteButton.self, "FailButton":FailButton.self
    ]
    var previousLabel: UILabel? {
        guard let index = selectedColumnViewTypes.index(of: "Previous") else { return nil }
        guard let pl = columnViews[index] as? UILabel else { fatalError() }
        return pl
    }
    var setNumberLabel: UILabel? {
        guard let index = selectedColumnViewTypes.index(of: "SetNumber") else { return nil }
        guard let snl = columnViews[index] as? UILabel else { fatalError() }
        return snl
    }
    var targetWeightTextField: UITextField? {
        guard let index = selectedColumnViewTypes.index(of: "TargetWeight") else { return nil }
        guard let twtf = columnViews[index] as? UITextField else { fatalError() }
        return twtf
    }
    var targetRepsTextField: UITextField? {
        guard let index = selectedColumnViewTypes.index(of: "TargetReps") else { return nil }
        guard let trtf = columnViews[index] as? UITextField else { fatalError() }
        return trtf
    }
    var completedWeightTextField: UITextField? {
        guard let index = selectedColumnViewTypes.index(of: "CompletedWeight") else { return nil }
        guard let cwtf = columnViews[index] as? UITextField else { fatalError() }
        return cwtf
    }
    var completedRepsTextField: UITextField? {
        guard let index = selectedColumnViewTypes.index(of: "CompletedReps") else { return nil }
        guard let crtf = columnViews[index] as? UITextField else { fatalError() }
        return crtf
    }
    var completeButton: UIButton? {
        guard let index = selectedColumnViewTypes.index(of: "CompleteButton") else { return nil }
        guard let cb = columnViews[index] as? UIButton else { fatalError() }
        return cb
    }
    var failButton: UIButton? {
        guard let index = selectedColumnViewTypes.index(of: "FailButton") else { return nil }
        guard let fb = columnViews[index] as? UIButton else { fatalError() }
        return fb
    }
    var db: DisposeBag!
}
