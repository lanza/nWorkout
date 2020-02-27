import RealmSwift
import UIKit

class WorkoutsDataSource<Cell: UITableViewCell>: DataSource<
    BaseDataProvider<NewWorkout>, Cell
  >
where Cell: ConfigurableCell, Cell.Object == NewWorkout {

  var name: String!

  init(tableView: UITableView, workouts: [NewWorkout]) {
    let provider = BaseDataProvider(objects: workouts)
    super.init(tableView: tableView, provider: provider)
  }

  override func initialSetup() {
    super.initialSetup()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 80
  }

  override func tableView(
    _ tableView: UITableView,
    canMoveRowAt indexPath: IndexPath
  ) -> Bool {
    return false
  }

  override func tableView(
    _ tableView: UITableView,
    canEditRowAt indexPath: IndexPath
  ) -> Bool {
    return true
  }

  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    guard editingStyle == .delete else { fatalError() }
    let strings = Lets.deleteConfirmationFor(name: name)
    let alert = UIAlertController(
      title: strings.title,
      message: strings.message,
      preferredStyle: .alert
    )
    let yes = UIAlertAction(title: Lets.yes, style: .default) { _ in
      self.deleteWorkout(at: indexPath)
    }
    let no = UIAlertAction(title: Lets.no, style: .cancel, handler: nil)
    alert.addAction(yes)
    alert.addAction(no)
    displayAlert(alert)
  }

  var displayAlert: ((UIAlertController) -> Void)!

  func deleteWorkout(at indexPath: IndexPath) {
    provider.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
    if provider.numberOfItems() == 0 {
      tableView.reloadData()
    }
  }
}
