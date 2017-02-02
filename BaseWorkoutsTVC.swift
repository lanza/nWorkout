import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import DZNEmptyDataSet

class BaseWorkoutsTVC<Cell: UITableViewCell>: UIViewController, UITableViewDelegate where Cell: ConfigurableCell, Cell.Object == Workout, Cell: ReusableView {
    
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

        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])        
        
        let ci = tableView.contentInset
        tableView.contentInset = UIEdgeInsets(top: ci.top + 20, left: ci.left, bottom: ci.bottom, right: ci.right)
        
        tableView.tableFooterView = UIView()
        navigationItem.leftBarButtonItem = editButtonItem
        
        
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    let db = DisposeBag()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIResponder.currentFirstResponder?.resignFirstResponder()
    }
    
}

protocol WorkoutsTVCDelegate: class {
    func workoutsTVC(_ workoutsTVC: WorkoutsTVC, didSelectWorkout workout: Workout)
    func routinesTVC(_ routinesTVC: RoutinesTVC, didSelectRoutine routine: Workout)
}
