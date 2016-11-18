import UIKit

class WorkoutDataSource: DataSource<Workout,WorkoutLiftCell> {
    
    var isActive = false
    
    override func initialSetup() {
        super.initialSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return isActive ? 3 : 1
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = UITableViewCell()
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Add Lift"
            case 1:
                cell.textLabel?.text = "Cancel Workout"
            case 2:
                cell.textLabel?.text = "Finish Workout"
            default: fatalError()
            }
            cell.textLabel?.textAlignment = .center
            return cell
        } else {
            let cell = super.tableView(tableView, cellForRowAt: indexPath) as! WorkoutLiftCell
            textFieldBehaviorHandler.setupSetConnections(for: cell)
                        
            let lift = provider.object(at: indexPath.row)
            cell.lift = lift
            
            cell.addSetButton.rx.tap.subscribe(onNext: {
                self.addSet(for: lift, and: cell)
            }).addDisposableTo(cell.db)
            return cell
        }
    }
    
    func addSet(for lift: Lift, and cell: LiftCell) {
        textFieldBehaviorHandler.currentlyEditingTextField?.resignFirstResponder()
        textFieldBehaviorHandler.currentlyEditingTextField = nil
        tableView.beginUpdates()
        let set = Set()
        RLM.write {
            if let last = lift.sets.last {
                set.weight = last.weight
                set.reps = last.reps
            } else {
                set.weight = 225
                set.reps = 5
            }
            lift.sets.append(set)
            cell.chartView.setup()
            self.textFieldBehaviorHandler.setupRowConnections(for: cell.chartView.rowViews.last as! SetRowView, cell: cell)
        }
        tableView.endUpdates()
    }
    
    var textFieldBehaviorHandler = TextFieldBehaviorHandler()

}
class TextFieldBehaviorHandler: KeyboardDelegate {
        var liftCells = [LiftCell]()
    
    var currentlyEditingLiftCell: LiftCell?
    var currentlyEditingRowView: SetRowView?
    var currentlyEditingTextField: UITextField?
    
    func setupSetConnections(for cell: LiftCell) {
        for setRowView in cell.rowViews {
            setupRowConnections(for: setRowView, cell: cell)
        }
    }
    
    func setupRowConnections(for setRowView: SetRowView, cell: LiftCell) {
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
            }).addDisposableTo(setRowView.db)
            setRowView.targetRepsTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
                guard let value = Int(setRowView.targetRepsTextField!.text!), value != setRowView.set.reps else { return }
                RLM.write {
                    setRowView.set.reps = value
                }
            }).addDisposableTo(setRowView.db)
            setRowView.completedWeightTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
                guard let value = Double(setRowView.completedWeightTextField!.text!), value != setRowView.set.completedWeight else { return }
                RLM.write {
                    setRowView.set.completedWeight = value
                }
            }).addDisposableTo(setRowView.db)
            setRowView.completedRepsTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
                guard let value = Int(setRowView.completedRepsTextField!.text!), value != setRowView.set.completedReps else { return }
                RLM.write {
                    setRowView.set.completedReps = value
                }
            }).addDisposableTo(setRowView.db)
    }
    
    func setupObserversForSettingBackTextAfterEditing(setRowView: SetRowView) {
        setRowView.targetWeightTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            if setRowView.targetWeightTextField?.text == "" {
                setRowView.targetWeightTextField?.text = setRowView.targetWeightTextField?.placeholder
            }
        }).addDisposableTo(setRowView.db)
        setRowView.targetRepsTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            if setRowView.targetRepsTextField?.text == "" {
                setRowView.targetRepsTextField?.text = setRowView.targetRepsTextField?.placeholder
            }
        }).addDisposableTo(setRowView.db)
        setRowView.completedWeightTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            if setRowView.completedWeightTextField?.text == "" {
                setRowView.completedWeightTextField?.text = setRowView.completedWeightTextField?.placeholder
            }
        }).addDisposableTo(setRowView.db)
        setRowView.completedRepsTextField?.rx.controlEvent(.editingDidEnd).subscribe(onNext: {
            if setRowView.completedRepsTextField?.text == "" {
                setRowView.completedRepsTextField?.text = setRowView.completedRepsTextField?.placeholder
            }
        }).addDisposableTo(setRowView.db)
    }
    
   
    func setupObserversForTextHandling(setRowView: SetRowView) {
        setRowView.targetWeightTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            guard setRowView.targetWeightTextField?.text != nil else { return }
            setRowView.targetWeightTextField?.placeholder = setRowView.targetWeightTextField?.text
            setRowView.targetWeightTextField?.text = nil
        }).addDisposableTo(setRowView.db)
        setRowView.targetRepsTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            guard setRowView.targetRepsTextField?.text != nil else { return }
            setRowView.targetRepsTextField?.placeholder = setRowView.targetRepsTextField?.text
            setRowView.targetRepsTextField?.text = nil
        }).addDisposableTo(setRowView.db)
        setRowView.completedWeightTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            guard setRowView.completedWeightTextField?.text != nil else { return }
            setRowView.completedWeightTextField?.placeholder = setRowView.completedWeightTextField?.text
            setRowView.completedWeightTextField?.text = nil
        }).addDisposableTo(setRowView.db)
        setRowView.completedRepsTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            guard setRowView.completedRepsTextField?.text != nil else { return }
            setRowView.completedRepsTextField?.placeholder = setRowView.completedRepsTextField?.text
            setRowView.completedRepsTextField?.text = nil
        }).addDisposableTo(setRowView.db)
    }
    
    func setupObserversForCurrentlyEditing(setRowView: SetRowView, cell: LiftCell) {
        setRowView.targetWeightTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            self.currentlyEditingLiftCell = cell
            self.currentlyEditingRowView = setRowView
            self.currentlyEditingTextField = setRowView.targetWeightTextField
        }).addDisposableTo(setRowView.db)
        setRowView.targetRepsTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            self.currentlyEditingLiftCell = cell
            self.currentlyEditingRowView = setRowView
            self.currentlyEditingTextField = setRowView.targetRepsTextField
        }).addDisposableTo(setRowView.db)
        setRowView.completedWeightTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            self.currentlyEditingLiftCell = cell
            self.currentlyEditingRowView = setRowView
            self.currentlyEditingTextField = setRowView.completedWeightTextField
        }).addDisposableTo(setRowView.db)
        setRowView.completedRepsTextField?.rx.controlEvent(.editingDidBegin).subscribe(onNext: {
            self.currentlyEditingLiftCell = cell
            self.currentlyEditingRowView = setRowView
            self.currentlyEditingTextField = setRowView.completedRepsTextField
        }).addDisposableTo(setRowView.db)
    }
    func hideWasTapped() {
        UIResponder.currentFirstResponder()?.resignFirstResponder()
    }
    
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
        }
    }
    func backspaceWasTapped() {
        currentlyEditingTextField?.deleteBackward()
    }
    func keyWasTapped(character: String) {
        currentlyEditingTextField!.text?.append(character)
    }
}

