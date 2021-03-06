import UIKit

class BaseWorkoutsTVC<Cell: UITableViewCell>: UITableViewController
where Cell: ConfigurableCell, Cell.Object == NWorkout {

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    tableView.setEditing(editing, animated: animated)
  }

  weak var delegate: WorkoutsTVCDelegate!

  var dataSource: WorkoutsDataSource<Cell>!
  var workouts: [NWorkout]!

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.tableFooterView = UIView()

    tableView.delegate = self
    tableView.separatorStyle = .none
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if tabBarController != nil {
      let ci = tableView.contentInset
      tableView.contentInset = UIEdgeInsets(
        top: ci.top,
        left: ci.left,
        bottom: 49,
        right: ci.right
      )
    }
  }

  override func tableView(
    _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
  ) {}

  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    UIResponder.currentFirstResponder?.resignFirstResponder()
  }

}

protocol WorkoutsTVCDelegate: AnyObject {
  func workoutsTVC(
    _ workoutsTVC: WorkoutsTVC,
    didSelectWorkout workout: NWorkout
  )

  func routinesTVC(
    _ routinesTVC: RoutinesTVC,
    didSelectRoutine routine: NWorkout
  )
}
