import UIKit
import RxSwift
import RxCocoa

extension WorkoutTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "WorkoutTVC" }
}

class WorkoutTVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: WorkoutDataSource!
    var workout: Workout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = WorkoutDataSource(tableView: tableView, provider: workout)
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {
            let lift = Lift()
            RLM.write {
                RLM.realm.add(lift)
                self.workout.lifts.append(lift)
            }
            let index = self.workout.index(of: lift)!
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }).addDisposableTo(db)
        
    }

    

    let db = DisposeBag()
}
