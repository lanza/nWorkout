import UIKit

protocol WorkoutDataSourceDelegate: AnyObject {
  func setRowView(_ setRowView: SetRowView, didTapNoteButtonForSet set: NSet)
  func liftCell(_ liftCell: LiftCell, didTapNoteButtonForLift lift: NLift)
}

class WorkoutDataSource<Cell: LiftCell>: DataSource<NWorkout, Cell> {

  var name: String!

  weak var delegate: WorkoutDataSourceDelegate!

  //START Specific to Workout
  init(
    tableView: UITableView,
    provider: NWorkout,
    activeOrFinished: ActiveOrFinished
  ) {
    self.activeOrFinished = activeOrFinished
    super.init(tableView: tableView, provider: provider)
  }

  var activeOrFinished: ActiveOrFinished!

  //END Specific to Workout

  override func initialSetup() {
    super.initialSetup()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 80

    setupFooterView()
  }

  func setupFooterView() {
    workoutFooterView = WorkoutFooterView.create(activeOrFinished)
    tableView.tableFooterView = workoutFooterView
  }

  var workoutFooterView: WorkoutFooterView!

  var buttonToCellDict: [UIButton: Cell] = [:]

  @objc func addSetButtonTapped(button: UIButton) {
    guard let cell = buttonToCellDict[button] else {
      fatalError("Fix this before release")
    }
    self.addSet(for: cell.lift, and: cell)
  }

  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  )
    -> UITableViewCell
  {
    let cell = super.tableView(tableView, cellForRowAt: indexPath) as! Cell
    textFieldBehaviorHandler.setupSetConnections(for: cell)

    let lift = provider.object(at: indexPath.row)
    cell.lift = lift

    buttonToCellDict[cell.addSetButton] = cell
    cell.addSetButton.addTarget(
      self, action: #selector(addSetButtonTapped(button:)), for: .touchUpInside)

    cell.delegate = self

    return cell
  }

  func addSet(for lift: NLift, and cell: LiftCell) {

    tableView.beginUpdates()

    textFieldBehaviorHandler.currentlyEditingTextField?.resignFirstResponder()
    textFieldBehaviorHandler.currentlyEditingTextField = nil

    _ = provider.addNewSet(for: lift)

    cell.chartView.setup()
    self.textFieldBehaviorHandler.setupRowConnections(
      for: cell.chartView.rowViews.last as! SetRowView,
      cell: cell
    )

    tableView.endUpdates()
  }

  lazy var textFieldBehaviorHandler: TextFieldBehaviorHandler = {
    let tfbh = TextFieldBehaviorHandler()
    tfbh.liftNeedsNewSet = { [unowned self] in
      self.addSet(
        for: tfbh.currentlyEditingLiftCell!.lift,
        and: tfbh.currentlyEditingLiftCell!
      )
    }
    return tfbh
  }()

  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    guard editingStyle == .delete else { fatalError() }
    provider.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
    if provider.numberOfItems() == 0 {
      tableView.reloadData()
    }
  }

  override func tableView(
    _ tableView: UITableView,
    canEditRowAt indexPath: IndexPath
  ) -> Bool {
    return true
  }

  override func tableView(
    _ tableView: UITableView,
    canMoveRowAt indexPath: IndexPath
  ) -> Bool {
    return true
  }

  override func tableView(
    _ tableView: UITableView,
    moveRowAt sourceIndexPath: IndexPath,
    to destinationIndexPath: IndexPath
  ) {
    provider.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
  }
}

extension WorkoutDataSource: LiftCellDelegate {
  func setRowView(_ setRowView: SetRowView, didTapNoteButtonForSet set: NSet) {
    delegate.setRowView(setRowView, didTapNoteButtonForSet: set)
  }

  func liftCell(_ liftCell: LiftCell, didTapNoteButtonForLift lift: NLift) {
    delegate.liftCell(liftCell, didTapNoteButtonForLift: lift)
  }
}
