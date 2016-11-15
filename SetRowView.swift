import UIKit
import ChartView

class RoutineSetRowView: SetRowView {
    override func setupSelectedColumnViewTypesAndWidth() {
        selectedColumnViewTypes = ["SetNumber","TargetWeight","TargetReps"]
        selectedColumnViewWidths = [10,45,45]
    }
}


class SetRowView: RowView {
    
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
        selectedColumnViewTypes = UserDefaults.standard.value(forKey: "selectedColumnViewTypes") as? [String] ?? ["SetNumber","TargetWeight","TargetReps","CompletedWeight","CompletedReps"]
        selectedColumnViewWidths = UserDefaults.standard.value(forKey: "selectedColumnViewWidths") as? [CGFloat] ?? [12,22,22,22,22]
    }
    
    let dict: [String:UIView.Type] = [
        "SetNumber":UILabel.self, "PreviousWeight":UILabel.self,
        "PreviousReps":UILabel.self, "TargetWeight":UITextField.self,
        "TargetReps":UITextField.self, "CompletedWeight":UITextField.self,
        "CompletedReps":UITextField.self, "Timer":UILabel.self,
        "Note":UIButton.self
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
}
