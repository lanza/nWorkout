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
            guard let set = set else { return }
            print(set.weight,set.reps,set.completedWeight,set.completedReps)
            noteButton?.update(for: set)
            
            if set.isComplete {
                setUI(for: .complete)
            } else if set.didFail {
                setUI(for: .fail)
            } else if set.isFresh {
                setUI(for: .fresh)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    required init() {
        super.init()
        
        columnBackgroundColor = Theme.Colors.darkest
        
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
    var isComplete = false
    var isFresh = false
    
    enum State {
        case fail
        case fresh
        case complete
    }
    
    func setUI(for state: State) {
        
        switch state {
        case .fail:
            failButton?.setFail(true)
            completeButton?.setComplete(false)
            
            isComplete = false
            isFresh = false
            didFail = true
            
            completedWeightTextField?.setNumber(double: set.failureWeight)
            completedRepsTextField?.setNumber(int: 0)
            
            completedWeightTextField?.isHidden = false
            completedRepsTextField?.isHidden = false
            completeButton?.setHide(true)
        case .complete:
            failButton?.setFail(false)
            completeButton?.setComplete(true)
            
            isComplete = true
            isFresh = false
            didFail = false
            
            completedWeightTextField?.setNumber(double: set.weight)
            completedRepsTextField?.setNumber(int: set.reps)
            
            completedWeightTextField?.isHidden = true
            completedRepsTextField?.isHidden = true
            completeButton?.setHide(false)
        case .fresh:
            failButton?.setFail(false)
            completeButton?.setComplete(false)
            
            isComplete = false
            isFresh = true
            didFail = false
            
            completedWeightTextField?.setNumber(double: 0)
            completedRepsTextField?.setNumber(int: 0)
            
            completedWeightTextField?.isHidden = true
            completedRepsTextField?.isHidden = true
            completeButton?.setHide(false)
        }
        
    }
    
    func setFailed() {
        setUI(for: .fail)
        set.setCompleted(weight: set.failureWeight, reps: 0)
        completedRepsTextField?.becomeFirstResponder()
    }
    
    func setComplete() {
        setUI(for: .complete)
        set.setCompleted(weight: set.weight, reps: set.reps)
    }
    func setFresh() {
        setUI(for: .fresh)
        set.setCompleted(weight: 0, reps: 0)
    }
    
    func setupButtons() {
        
        failButton?.rx.tap.subscribe(onNext: { [unowned self] in
            if self.didFail {
                self.setFresh()
            } else {
                self.setFailed()
            }
        }).addDisposableTo(db)
        
        completeButton?.rx.tap.subscribe(onNext: { [unowned self] in
            if self.isComplete {
                self.setFresh()
            } else {
                self.setComplete()
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
