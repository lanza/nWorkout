import UIKit
import RxCocoa
import RxSwift
import RealmSwift

class RLM {
    static let realm = try! Realm()
    static func write(transaction: ()->()) {
        do {
            try realm.write(transaction)
        } catch let error {
            print(error)
        }
    }
}

extension RoutinesTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "RoutinesTVC" }
}

class RoutinesTVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: RoutinesDataSource!
    var routines: Results<Workout>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        routines = RLM.realm.objects(Workout.self).filter("isWorkout = false").sorted(byProperty: "name")
        dataSource = RoutinesDataSource(tableView: tableView, workouts: routines)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {
            let alert = UIAlertController(title: "Create new Routine", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                
            }
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default) { action in
                guard let name = alert.textFields?.first?.text else { fatalError() }
               
                let routine = Workout()
                routine.name = name
                RLM.write {
                    RLM.realm.add(routine)
                }
               
                guard let index = self.routines.index(of: routine) else { fatalError() }
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }).addDisposableTo(db)
        
        
    }
    

    var didSelectRoutine: ((Workout) -> ())!
    let db = DisposeBag()
}

extension RoutinesTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routine = routines[indexPath.row]
        didSelectRoutine(routine)
    }
}












