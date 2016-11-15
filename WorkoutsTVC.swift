import UIKit
import RealmSwift
import RxSwift
import RxCocoa

extension WorkoutsTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "WorkoutsTVC" }
}

class WorkoutsTVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: WorkoutsDataSource!
    var workouts: Results<Workout>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        workouts = RLM.realm.objects(Workout.self).filter("isWorkout = true").sorted(byProperty: "startDate")
        dataSource = WorkoutsDataSource(tableView: tableView, workouts: workouts)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        
    }
   
    var didSelectWorkout: ((Workout) -> ())!
    let db = DisposeBag()
}

extension WorkoutsTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = workouts[indexPath.row]
        didSelectWorkout(workout)
    }
}
