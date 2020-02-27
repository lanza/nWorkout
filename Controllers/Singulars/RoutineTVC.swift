import RxCocoa
import RxSwift
import UIKit

class RoutineTVC: BaseWorkoutTVC<RoutineLiftCell> {

  override func setDataSource() {
    dataSource = WorkoutDataSource(
      tableView: tableView,
      provider: workout,
      activeOrFinished: .finished
    )
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = workout.name
  }
}
