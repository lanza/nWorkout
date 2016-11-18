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
    
    var keyboardHandler: KeyboardHandler!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Keyboard.shared.delegate = dataSource.textFieldBehaviorHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        dataSource = RoutineDataSource(tableView: tableView, provider: routine)
        tableView.tableFooterView = UIView()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        keyboardHandler = KeyboardHandler.new(tableView: tableView, view: view)
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "chartViewWillDelete")).subscribe(onNext: { noti in
            self.tableView.beginUpdates()
        }).addDisposableTo(db)
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "chartViewDidDelete")).subscribe(onNext: { noti in
            self.tableView.endUpdates()
        }).addDisposableTo(db)
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
