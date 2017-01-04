import UIKit

class WorkoutDataSource<Cell: LiftCell>: DataSource<Workout,Cell> where Cell: ConfigurableCell, Cell.Object == Lift, Cell: ReusableView {
    
    var name: String!
    
    //START Specific to Workout
    init(tableView: UITableView, provider: Workout, activeOrFinished: ActiveOrFinished) {
        self.activeOrFinished = activeOrFinished
        super.init(tableView: tableView, provider: provider)
    }
    var activeOrFinished: ActiveOrFinished!
    //END Specific to Workout
    
    override func initialSetup() {
        super.initialSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        setupFooterView()
    }
    
    func setupFooterView() {
        workoutFooterView = WorkoutFooterView.create(activeOrFinished)
        tableView.tableFooterView = workoutFooterView
    }
    
    var workoutFooterView: WorkoutFooterView!
    var addLiftButton: UIButton { return workoutFooterView.addLiftButton }
    // START Workout only
    var cancelWorkoutButton: UIButton { return workoutFooterView.cancelWorkoutButton }
    var finishWorkoutButtoon: UIButton { return workoutFooterView.finishWorkoutButton }
    // END Workout only
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! Cell
        textFieldBehaviorHandler.setupSetConnections(for: cell)
        
        let lift = provider.object(at: indexPath.row)
        cell.lift = lift
        
        cell.addSetButton.rx.tap.subscribe(onNext: {
            self.addSet(for: lift, and: cell)
        }).addDisposableTo(cell.db)
        return cell
    }
    
    func addSet(for lift: Lift, and cell: LiftCell) {
        textFieldBehaviorHandler.currentlyEditingTextField?.resignFirstResponder()
        textFieldBehaviorHandler.currentlyEditingTextField = nil
        
        tableView.beginUpdates()
        
        _ = provider.addNewSet(for: lift)
        
        cell.chartView.setup()
        self.textFieldBehaviorHandler.setupRowConnections(for: cell.chartView.rowViews.last as! SetRowView, cell: cell)
        
        tableView.endUpdates()
    }
    
    lazy var textFieldBehaviorHandler: TextFieldBehaviorHandler = {
        let tfbh = TextFieldBehaviorHandler()
        tfbh.liftNeedsNewSet = { [unowned self] in
            self.addSet(for: tfbh.currentlyEditingLiftCell!.lift, and:  tfbh.currentlyEditingLiftCell!)
        }
        return tfbh
    }()
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { fatalError() }
        provider.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if provider.numberOfItems() == 0 {
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        provider.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}





























