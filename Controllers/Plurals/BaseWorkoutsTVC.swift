import DZNEmptyDataSet
import RealmSwift
import RxCocoa
import RxSwift
import UIKit

class BaseWorkoutsTVC<Cell: UITableViewCell>: UIViewController,
  UITableViewDelegate
where Cell: ConfigurableCell, Cell.Object == Workout {

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    tableView.setEditing(editing, animated: animated)
  }

  let tableView = UITableView()

  weak var delegate: WorkoutsTVCDelegate!

  var dataSource: WorkoutsDataSource<Cell>!
  var workouts: Results<Workout>!

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = Theme.Colors.darkest

    let v = UIView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: UIApplication.shared.windows[0].frame.width,
        height: 20
      )
    )
    v.backgroundColor = Theme.Colors.darkest
    view.addSubview(v)
    v.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        v.topAnchor.constraint(equalTo: view.topAnchor),
        v.leftAnchor.constraint(equalTo: view.leftAnchor),
        v.rightAnchor.constraint(equalTo: view.rightAnchor),
        v.heightAnchor.constraint(equalToConstant: 20),

        tableView.topAnchor.constraint(equalTo: v.bottomAnchor),
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        tableView.bottomAnchor.constraint(
          equalTo: bottomLayoutGuide.bottomAnchor
        ),
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
      ]
    )

    tableView.tableFooterView = UIView()
    navigationItem.leftBarButtonItem = editButtonItem

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

  let db = DisposeBag()

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {}

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    UIResponder.currentFirstResponder?.resignFirstResponder()
  }

}

protocol WorkoutsTVCDelegate: class {
  func workoutsTVC(
    _ workoutsTVC: WorkoutsTVC,
    didSelectWorkout workout: Workout
  )

  func routinesTVC(
    _ routinesTVC: RoutinesTVC,
    didSelectRoutine routine: Workout
  )
}
