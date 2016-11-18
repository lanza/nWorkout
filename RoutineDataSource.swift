import UIKit

class RoutineDataSource: DataSource<Workout,RoutineLiftCell> {
    
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
            return 1
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Add Lift"
            cell.textLabel?.textAlignment = .center
            return cell
        } else {
            let cell = super.tableView(tableView, cellForRowAt: indexPath) as! RoutineLiftCell
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
    
    lazy var textFieldBehaviorHandler: TextFieldBehaviorHandler = {
        let tfbh = TextFieldBehaviorHandler()
        tfbh.liftNeedsNewSet = { [unowned self] in
            self.addSet(for: tfbh.currentlyEditingLiftCell!.lift, and:  tfbh.currentlyEditingLiftCell!)
        }
        return tfbh
    }()
}
