import UIKit
import ChartView
import RxSwift
import RxCocoa
import CustomIOSAlertView

protocol SetRowViewDelegate: class {
    func setRowView(_ setRowView: SetRowView, didTapNoteButtonForSet set: Set)
}

class SetRowView: RowView {
   
    weak var delegate: SetRowViewDelegate!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        set = nil
    }
    override func setupColumns() {
        super.setupColumns()
        db = DisposeBag()
        setupButtons()
    }
    
    var set: (nWorkout.Set)! {
        didSet {
            if let set = set {
                didFail = set.didFail
                didSetDidFail()
                isComplete = set.isComplete
                didSetIsComplete()
                noteButton?.update(for: set)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    required init() {
        super.init()
        
        columnBackgroundColor = Theme.Colors.Cell.contentBackground
        
        setupSelectedColumnViewTypesAndWidth()
        configColumnViewTypes()
        configColumnWidthPercentages()
    }
    let viewInfos = ViewInfo.saved
    var selectedColumnViewTypes: [String]!
    var selectedColumnViewWidths: [CGFloat]!
    
    func setupSelectedColumnViewTypesAndWidth() {
        selectedColumnViewTypes = viewInfos.filter { $0.isOn }.map { $0.name }
        selectedColumnViewWidths = viewInfos.filter { $0.isOn }.map { $0.width }
    }
    
    func configColumnViewTypes() {
        columnViewTypes = selectedColumnViewTypes.map { dict[$0]! }
    }
    func configColumnWidthPercentages() {
        let sum = selectedColumnViewWidths.reduce(0, +)
        columnWidths = selectedColumnViewWidths.map { ($0 * 100) / sum }
    }
    let usesCombinedView = ViewInfo.usesCombinedView
    
    var didFail = false
    func didSetDidFail() {
        failButton?.setFail(didFail)

        if didFail {
            isComplete = false
            completeButton?.setComplete(false)
        }
        
        self.completedWeightTextField?.setNumber(double: self.didFail ? self.set.failureWeight() : 0 )
        self.completedRepsTextField?.setNumber(int: 0)
        
        if usesCombinedView {
            completedWeightTextField?.isHidden = !didFail
            completedRepsTextField?.isHidden = !didFail
            completeButton?.setHide(didFail)
        }
    }
    var isComplete = false
    func didSetIsComplete() {
        completeButton?.setComplete(isComplete)
        if isComplete {
            failButton?.setFail(false)
            didFail = false
        }
        
        self.completedWeightTextField?.setNumber(double: self.didFail ? self.set.failureWeight() : 0 )
        self.completedRepsTextField?.setNumber(int: 0)
    }
    
    func setupButtons() {
        failButton?.rx.tap.subscribe(onNext: { [unowned self] in
            self.didFail = !self.didFail
            self.didSetDidFail()
            
            RLM.write {
                self.set.completedWeight = self.didFail ? self.set.failureWeight() : 0
                self.set.completedReps = 0
            }
            if self.didFail {
                self.completedRepsTextField?.becomeFirstResponder()
            }
        }).addDisposableTo(db)
        completeButton?.rx.tap.subscribe(onNext: { [unowned self] in
            self.isComplete = !self.isComplete
            self.didSetIsComplete()
            
            RLM.write {
                self.set.completedWeight = self.isComplete ? self.set.weight : 0
                self.set.completedReps = self.isComplete ? self.set.reps : 0
            }
        }).addDisposableTo(db)
        noteButton?.rx.tap.subscribe(onNext: { [unowned self] in
            self.delegate.setRowView(self, didTapNoteButtonForSet: self.set)
        }).addDisposableTo(db)
    }
    
    let dict: [String:UIView.Type] = [
        Lets.setNumberKey:SetNumberLabel.self,
        Lets.previousWorkoutKey:WeightAndRepsLabelHolder.self,
        Lets.targetWeightKey:WeightAndRepsTextField.self,
        Lets.targetRepsKey:WeightAndRepsTextField.self,
        Lets.completedWeightKey:CompletedWeightAndRepsTextField.self,
        Lets.completedRepsKey:CompletedWeightAndRepsTextField.self,
        "Timer":UILabel.self,
        Lets.noteButtonKey:NoteButton.self,
        Lets.doneButtonKey:CompleteButton.self,
        Lets.failButtonKey:FailButton.self,
        Lets.doneButtonCompletedWeightCompletedRepsKey:CombinedView.self
    ]
    
    
    var combinedView: CombinedView? {
        guard usesCombinedView else { return nil }
        guard let index = selectedColumnViewTypes.index(of: Lets.doneButtonCompletedWeightCompletedRepsKey) else { return nil }
        guard let cv = columnViews[index] as? CombinedView else { fatalError() }
        return cv
    }
    
    var previousLabel: WeightAndRepsLabelHolder? {
        guard let index = selectedColumnViewTypes.index(of: Lets.previousWorkoutKey) else { return nil }
        guard let pl = columnViews[index] as? WeightAndRepsLabelHolder else { fatalError() }
        return pl
    }
    var setNumberLabel: SetNumberLabel? {
        guard let index = selectedColumnViewTypes.index(of: Lets.setNumberKey) else { return nil }
        guard let snl = columnViews[index] as? SetNumberLabel else { fatalError() }
        return snl
    }
    var targetWeightTextField: WeightAndRepsTextField? {
        guard let index = selectedColumnViewTypes.index(of: Lets.targetWeightKey) else { return nil }
        guard let twtf = columnViews[index] as? WeightAndRepsTextField else { fatalError() }
        return twtf
    }
    var targetRepsTextField: WeightAndRepsTextField? {
        guard let index = selectedColumnViewTypes.index(of: Lets.targetRepsKey) else { return nil }
        guard let trtf = columnViews[index] as? WeightAndRepsTextField else { fatalError() }
        return trtf
    }
    var completedWeightTextField: CompletedWeightAndRepsTextField? {
        if let cv = combinedView {
            return cv.completedWeightTextField
        }
        guard let index = selectedColumnViewTypes.index(of: Lets.completedWeightKey) else { return nil }
        guard let cwtf = columnViews[index] as? CompletedWeightAndRepsTextField else { fatalError() }
        return cwtf
    }
    var completedRepsTextField: CompletedWeightAndRepsTextField? {
        if let cv = combinedView {
            return cv.completedRepsTextField
        }
        guard let index = selectedColumnViewTypes.index(of: Lets.completedRepsKey) else { return nil }
        guard let crtf = columnViews[index] as? CompletedWeightAndRepsTextField else { fatalError() }
        return crtf
    }
    var completeButton: CompleteButton? {
        if let cv = combinedView {
            return cv.completeButton
        }
        guard let index = selectedColumnViewTypes.index(of: Lets.doneButtonKey) else { return nil }
        guard let cb = columnViews[index] as? CompleteButton else { fatalError() }
        return cb
    }
    var failButton: FailButton? {
        guard let index = selectedColumnViewTypes.index(of: Lets.failButtonKey) else { return nil }
        guard let fb = columnViews[index] as? FailButton else { fatalError() }
        return fb
    }
    var noteButton: NoteButton? {
        guard let index = selectedColumnViewTypes.index(of: Lets.noteButtonKey) else { return nil }
        guard let nb = columnViews[index] as? NoteButton else { fatalError() }
        return nb
    }
    var db: DisposeBag!
    var textFieldDB: DisposeBag!
}
