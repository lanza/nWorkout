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
    var isActive: Bool { return !workout.isComplete }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Keyboard.shared.delegate = dataSource.textFieldBehaviorHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        dataSource = WorkoutDataSource(tableView: tableView, provider: workout)
        dataSource.isActive = isActive
        tableView.tableFooterView = UIView()
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    func addNewLift(name: String) {
        let lift = Lift()
        RLM.write {
            lift.name = name
            lift._previousStrings = UserDefaults.standard.value(forKey: "last" + lift.name) as? String ?? ""
            RLM.realm.add(lift)
            self.workout.lifts.append(lift)
        }
        let index = self.workout.index(of: lift)!
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    var didTapAddNewLift: (() -> ())!
    var didFinishWorkout: (() -> ())!
    var didCancelWorkout: (() -> ())!

    let db = DisposeBag()
}

extension WorkoutTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                didTapAddNewLift()
            case 1:
                didCancelWorkout()
            case 2:
                didFinishWorkout()
            default: fatalError()
            }
        }
    }
}



