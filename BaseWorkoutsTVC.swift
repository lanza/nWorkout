import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import DZNEmptyDataSet

class BaseWorkoutsTVC<Cell: UITableViewCell>: BaseTVC, UITableViewDelegate where Cell: ConfigurableCell, Cell.Object == Workout {

    weak var delegate: WorkoutsTVCDelegate!
    
    var dataSource: WorkoutsDataSource<Cell>!
    var workouts: Results<Workout>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    let db = DisposeBag()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

//extension BaseWorkoutsTVC: UITableViewDelegate {}

protocol WorkoutsTVCDelegate: class {
    func workoutsTVC(_ workoutsTVC: WorkoutsTVC, didSelectWorkout workout: Workout)
    func routinesTVC(_ routinesTVC: RoutinesTVC, didSelectRoutine routine: Workout)
}
