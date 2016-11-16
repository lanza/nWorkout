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
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

class SetRowView: RowView {
    
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
        selectedColumnViewTypes = UserDefaults.standard.value(forKey: "selectedColumnViewTypes") as? [String] ?? ["SetNumber","TargetWeight","TargetReps","CompletedWeight","CompletedReps","CompleteButton"]
        selectedColumnViewWidths = UserDefaults.standard.value(forKey: "selectedColumnViewWidths") as? [CGFloat] ?? [12,22,22,22,22,12]
    }
    
    let dict: [String:UIView.Type] = [
        "SetNumber":SetNumberLabel.self, "PreviousWeight":WeightAndRepsLabel.self,
        "PreviousReps":WeightAndRepsLabel.self, "TargetWeight":WeightAndRepsTextField.self,
        "TargetReps":WeightAndRepsTextField.self, "CompletedWeight":WeightAndRepsTextField.self,
        "CompletedReps":WeightAndRepsTextField.self, "Timer":UILabel.self,
        "Note":UIButton.self, "CompleteButton":UIButton.self
    ]
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
    var db = DisposeBag()
}
