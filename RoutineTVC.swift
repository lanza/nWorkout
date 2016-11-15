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
        tableView.delegate = self
        dataSource = RoutineDataSource(tableView: tableView, provider: routine)
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    func addNewLift(name: String) {
        let lift = Lift()
        RLM.write {
            lift.name = name
            RLM.realm.add(lift)
            self.routine.lifts.append(lift)
        }
        let index = self.routine.index(of: lift)!
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
   
    var didTapAddNewLift: (() -> ())!
    
    let db = DisposeBag()
}

extension RoutineTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            didTapAddNewLift()
        }
    }
}
