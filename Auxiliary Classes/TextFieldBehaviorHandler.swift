import UIKit
import RxSwift

class TextFieldBehaviorHandler: KeyboardDelegate {
//    var liftCells = [LiftCell]()
    
    var currentlyEditingLiftCell: LiftCell?
    var currentlyEditingRowView: SetRowView?
    var currentlyEditingTextField: UITextField?
    
    func setupSetConnections(for cell: LiftCell) {
        for setRowView in cell.rowViews {
            setupRowConnections(for: setRowView, cell: cell)
        }
    }
    
    func setupRowConnections(for setRowView: SetRowView, cell: LiftCell) {
        setRowView.textFieldDB = DisposeBag()
        setupObserversForCurrentlyEditing(setRowView: setRowView, cell: cell)
        setupObserversForTextHandling(setRowView: setRowView)
        setupObserversForSettingBackTextAfterEditing(setRowView: setRowView)
        setupObserversForUpdatingSetValues(setRowView: setRowView)
    }
    
    func setupObserversForUpdatingSetValues(setRowView: SetRowView) {
        setRowView.targetWeightTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            guard let value = Double(setRowView.targetWeightTextField!.text!), value != setRowView.set.weight else { return }
            RLM.write {
                setRowView.set.weight = value
            }
        }).disposed(by: setRowView.textFieldDB)
        setRowView.targetRepsTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            guard let value = Int(setRowView.targetRepsTextField!.text!), value != setRowView.set.reps else { return }
            RLM.write {
                setRowView.set.reps = value
            }
        }).disposed(by: setRowView.textFieldDB)
        setRowView.completedWeightTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            guard let value = Double(setRowView.completedWeightTextField!.text!), value != setRowView.set.completedWeight else { return }
            RLM.write {
                setRowView.set.completedWeight = value
            }
        }).disposed(by: setRowView.textFieldDB)
        setRowView.completedRepsTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            guard let value = Int(setRowView.completedRepsTextField!.text!), value != setRowView.set.completedReps else { return }
            RLM.write {
                setRowView.set.completedReps = value
            }
        }).disposed(by: setRowView.textFieldDB)
    }
    
    func setupObserversForSettingBackTextAfterEditing(setRowView: SetRowView) {
        setRowView.targetWeightTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            if setRowView.targetWeightTextField?.text == "" {
                setRowView.targetWeightTextField?.text = setRowView.targetWeightTextField?.placeholder
            }
        }).disposed(by: setRowView.textFieldDB)
        setRowView.targetRepsTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            if setRowView.targetRepsTextField?.text == "" {
                setRowView.targetRepsTextField?.text = setRowView.targetRepsTextField?.placeholder
            }
        }).disposed(by: setRowView.textFieldDB)
        setRowView.completedWeightTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            if setRowView.completedWeightTextField?.text == "" {
                setRowView.completedWeightTextField?.text = setRowView.completedWeightTextField?.placeholder
            }
        }).disposed(by: setRowView.textFieldDB)
        setRowView.completedRepsTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            if setRowView.completedRepsTextField?.text == "" {
                setRowView.completedRepsTextField?.text = setRowView.completedRepsTextField?.placeholder
            }
        }).disposed(by: setRowView.textFieldDB)
    }
    
    
    func setupObserversForTextHandling(setRowView: SetRowView) {
        if let twtf = setRowView.targetWeightTextField {
            twtf.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
                guard twtf.text != nil else { return }
                twtf.placeholder = twtf.text
                twtf.text = nil
            }).disposed(by: setRowView.textFieldDB)
        }
        setRowView.targetRepsTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            guard setRowView.targetRepsTextField?.text != nil else { return }
            setRowView.targetRepsTextField?.placeholder = setRowView.targetRepsTextField?.text
            setRowView.targetRepsTextField?.text = nil
        }).disposed(by: setRowView.textFieldDB)
        setRowView.completedWeightTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            guard setRowView.completedWeightTextField?.text != nil else { return }
            setRowView.completedWeightTextField?.placeholder = setRowView.completedWeightTextField?.text
            setRowView.completedWeightTextField?.text = nil
        }).disposed(by: setRowView.textFieldDB)
        setRowView.completedRepsTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            guard setRowView.completedRepsTextField?.text != nil else { return }
            setRowView.completedRepsTextField?.placeholder = setRowView.completedRepsTextField?.text
            setRowView.completedRepsTextField?.text = nil
        }).disposed(by: setRowView.textFieldDB)
    }
    
    func setupObserversForCurrentlyEditing(setRowView: SetRowView, cell: LiftCell) {
        setRowView.targetWeightTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            self.currentlyEditingLiftCell = cell
            self.currentlyEditingRowView = setRowView
            self.currentlyEditingTextField = setRowView.targetWeightTextField
        }).disposed(by: setRowView.textFieldDB)
        setRowView.targetRepsTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            self.currentlyEditingLiftCell = cell
            self.currentlyEditingRowView = setRowView
            self.currentlyEditingTextField = setRowView.targetRepsTextField
        }).disposed(by: setRowView.textFieldDB)
        setRowView.completedWeightTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            self.currentlyEditingLiftCell = cell
            self.currentlyEditingRowView = setRowView
            self.currentlyEditingTextField = setRowView.completedWeightTextField
        }).disposed(by: setRowView.textFieldDB)
        setRowView.completedRepsTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            self.currentlyEditingLiftCell = cell
            self.currentlyEditingRowView = setRowView
            self.currentlyEditingTextField = setRowView.completedRepsTextField
        }).disposed(by: setRowView.textFieldDB)
    }
    func hideWasTapped() {
        UIResponder.currentFirstResponder?.resignFirstResponder()
    }
    
    var liftNeedsNewSet: (()->())!
    
    func getNeighborTextField(for textField: UITextField) -> UITextField? {
        guard let cerv = currentlyEditingRowView else { fatalError() }
        if textField === cerv.targetWeightTextField {
            if let trtf = cerv.targetRepsTextField, trtf.isHidden == false {
                return trtf
            } else if let cwtf = cerv.completedWeightTextField, cwtf.isHidden == false {
                return cwtf
            } else if let crtf = cerv.completedRepsTextField, crtf.isHidden == false {
                return crtf
            } else {
                return nil
            }
        } else if textField === cerv.targetRepsTextField {
            if let cwtf = cerv.completedWeightTextField, cwtf.isHidden == false {
                return cwtf
            } else if let crtf = cerv.completedRepsTextField, crtf.isHidden == false {
                return crtf
            } else {
                return nil
            }
        } else if textField === cerv.completedWeightTextField {
            if let crtf = cerv.completedRepsTextField, crtf.isHidden == false {
                return crtf
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func nextWasTapped() {
        guard let cetf = currentlyEditingTextField, var cerv = currentlyEditingRowView, let celc = currentlyEditingLiftCell else { fatalError() }
        
        if let neighbor = getNeighborTextField(for: cetf) {
            neighbor.becomeFirstResponder()
        } else if let rowIndex = celc.rowViews.index(of: cerv), celc.rowViews.count > rowIndex + 1 {
            currentlyEditingRowView = celc.rowViews[rowIndex + 1]
            cerv = currentlyEditingRowView!
            if let twtf = cerv.targetWeightTextField {
                twtf.becomeFirstResponder()
            } else if let trtf = cerv.targetRepsTextField {
                trtf.becomeFirstResponder()
            } else if let cwtf = cerv.completedWeightTextField {
                cwtf.becomeFirstResponder()
            } else if let crtf = cerv.completedRepsTextField {
                crtf.becomeFirstResponder()
            } else {
                cetf.resignFirstResponder()
                currentlyEditingTextField = nil
                currentlyEditingRowView = nil
                currentlyEditingLiftCell = nil
            }
        } else {
            liftNeedsNewSet()
            currentlyEditingLiftCell?.rowViews.last!.targetWeightTextField?.becomeFirstResponder()
        }
    }
    func backspaceWasTapped() {
        currentlyEditingTextField?.deleteBackward()
    }
    func keyWasTapped(character: String) {
        currentlyEditingTextField!.text?.append(character)
    }
}
