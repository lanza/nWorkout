import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import DZNEmptyDataSet

extension WorkoutsTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "WorkoutsTVC" }
}

class WorkoutsTVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: WorkoutsDataSource!
    var workouts: Results<Workout>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        workouts = RLM.realm.objects(Workout.self).filter("isWorkout = true").filter("isComplete = true").sorted(byProperty: "startDate")
        dataSource = WorkoutsDataSource(tableView: tableView, workouts: workouts)
        dataSource.displayAlert = { alert in
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        navigationItem.leftBarButtonItem = editButtonItem
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

extension WorkoutsTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "workout")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "You have not done any workouts")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Click the + at the bottom to start your first workout or the \"Routines\" tab to set up a routine")
    }
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
//        return NSAttributedString(string: "This is the button title")
//    }
}
