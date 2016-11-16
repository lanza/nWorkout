import UIKit
import RxCocoa
import RxSwift
import RealmSwift
import DZNEmptyDataSet

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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: RoutinesDataSource!
    var routines: Results<Workout>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        routines = RLM.realm.objects(Workout.self).filter("isWorkout = false").sorted(byProperty: "name")
        dataSource = RoutinesDataSource(tableView: tableView, workouts: routines)
        
        dataSource.displayAlert = { alert in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        
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
               
                self.dataSource.provider.append(routine)
                guard let index = self.dataSource.provider.index(of: routine) else { fatalError() }
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                if self.dataSource.provider.numberOfItems() == 1 {
                    self.tableView.reloadData()
                }
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


extension RoutinesTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "routine")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "You do not have any routines, yet!")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Click the + at the top to add your first routine.")
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
}









