import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet

extension RoutineTVC: ViewControllerFromStoryboard {
}

class RoutineTVC: UIViewController {
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: RoutineDataSource!
    var routine: Workout!
    
    var keyboardHandler: KeyboardHandler!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        Keyboard.shared.delegate = dataSource.textFieldBehaviorHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        dataSource = RoutineDataSource(tableView: tableView, provider: routine)
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        keyboardHandler = KeyboardHandler.new(tableView: tableView, view: view)
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "chartViewWillDelete")).subscribe(onNext: { noti in
            self.tableView.beginUpdates()
        }).addDisposableTo(db)
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "chartViewDidDelete")).subscribe(onNext: { noti in
            self.tableView.endUpdates()
        }).addDisposableTo(db)
        
        dataSource.addLiftButton.rx.tap.subscribe(onNext: {
            self.didTapAddNewLift()
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

}

extension RoutineTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "routine")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "You have not added any lifts, yet!")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Click \"Add Lift\" to add a new exercise to your Routine.")
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
}
