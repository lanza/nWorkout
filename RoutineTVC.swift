import UIKit
import RxSwift
import RxCocoa

extension RoutineTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "RoutineTVC" }
}

class RoutineTVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: RoutineDataSource!
    var routine: Workout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = RoutineDataSource(tableView: tableView, provider: routine)
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {
            let lift = Lift()
            lift.isWorkout = false
            RLM.write {
                RLM.realm.add(lift)
                self.routine.lifts.append(lift)
            }
            let index = self.routine.index(of: lift)!
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }).addDisposableTo(db)
    }
    let db = DisposeBag()
}

