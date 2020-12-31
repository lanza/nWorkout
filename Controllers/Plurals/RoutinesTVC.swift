import UIKit

class RoutinesTVC: BaseWorkoutsTVC<RoutineCell> {

  func setTableHeaderView() {
    let b = UIButton()
    b.setTitle("New")
    b.setTitleColor(.white)
    b.addTarget(self, action: #selector(newButtonTapped), for: .touchUpInside)
  }

  @objc func newButtonTapped() {
    let alert = UIAlertController.alert(
      title: Lets.createNewRoutine,
      message: nil
    )

    alert.addAction(
      UIAlertAction(title: Lets.done, style: UIAlertAction.Style.default) {
        _ in
        guard let name = alert.textFields?.first?.text else { fatalError() }

        let routine = NWorkout.new(
          isComplete: false,
          name: name
        )

        self.dataSource.provider.append(routine)

        guard let index = self.dataSource.provider.index(of: routine) else {
          fatalError()
        }
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        if self.dataSource.provider.numberOfItems() == 1 {
          self.tableView.reloadData()
        }
        self.delegate!.routinesTVC(self, didSelectRoutine: routine)
      }
    )
    alert.addAction(
      UIAlertAction(title: Lets.cancel, style: .cancel, handler: nil)
    )
    self.present(alert, animated: true, completion: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    workouts = [NWorkout]()
      .sorted(by: { $0.name! > $1.name! })

    dataSource = WorkoutsDataSource(tableView: tableView, workouts: workouts)
    dataSource.name = Lets.routine
    dataSource.displayAlert = { alert in
      self.present(alert, animated: true, completion: nil)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setTableHeaderView()
  }

  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let routine = dataSource.provider.object(at: indexPath.row)
    delegate!.routinesTVC(self, didSelectRoutine: routine)
  }
}
