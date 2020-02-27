import BonMot
import RealmSwift
import RxCocoa
import RxSwift
import UIKit

class WorkoutsTVC: BaseWorkoutsTVC<WorkoutCell> {

  func setTableHeaderView() {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
    let label = UILabel()
    label.text = "History"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 28)

    view.addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false

    label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive
      = true
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    tableView.tableHeaderView = view
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)

    workouts = RLM.realm.objects(Workout.self).filter("isWorkout = true")
      .filter(
        "isComplete = true"
      ).sorted(byKeyPath: "startDate", ascending: false)

    dataSource = WorkoutsDataSource(tableView: tableView, workouts: workouts)
    dataSource.name = Lets.workout
    dataSource.displayAlert = { alert in
      self.present(alert, animated: true, completion: nil)
    }

  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()

    setTableHeaderView()

    navigationItem.leftBarButtonItem = editButtonItem
  }

  //mark: - Swift is so fucking stupid
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let workout = workouts[indexPath.row]
    delegate!.workoutsTVC(self, didSelectWorkout: workout)
  }
}
