import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import CustomIOSAlertView

class BaseWorkoutTVC<Cell: LiftCell>: BaseTVC, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, WorkoutDataSourceDelegate, CustomIOSAlertViewDelegate where Cell: ConfigurableCell, Cell.Object == Lift, Cell: ReusableView {
    
    var dataSource: WorkoutDataSource<Cell>!
    var workout: Workout!
    
    var keyboardHandler: KeyboardHandler!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Keyboard.shared.delegate = dataSource.textFieldBehaviorHandler
    }
    
    func setDataSource() {
        fatalError()
    }
    func setEmptyDataSet() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataSource()
        setEmptyDataSet()
        dataSource.delegate = self
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        keyboardHandler = KeyboardHandler.new(tableView: tableView, view: view)
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: Lets.chartViewWillDeleteNotificationName)).subscribe(onNext: { noti in
            self.tableView.beginUpdates()
        }).addDisposableTo(db)
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: Lets.chartViewDidDeleteNotificationName)).subscribe(onNext: { noti in
            self.tableView.endUpdates()
        }).addDisposableTo(db)
        
        dataSource.addLiftButton.rx.tap.subscribe(onNext: {
            self.didTapAddNewLift()
        }).addDisposableTo(db)
    }
    
    func addNewLift(name: String) {
        let lift = workout.addNewLift(name: name)
        
        let index = workout.index(of: lift)!
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    var didTapAddNewLift: (() -> ())!
    
    let db = DisposeBag()
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "workout")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "You have not added any lifts, yet!")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Click \"Add Lift\" to add a new exercise to your Workout.")
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
    func setRowView(_ setRowView: SetRowView, didTapNoteButtonForSet set: Set) {
        let a = CustomIOSAlertView()
        a?.containerView = NoteView.new(for: set)
        a?.delegate = self
        a?.show()
    }
    func liftCell(_ liftCell: LiftCell, didTapNoteButtonForLift lift: Lift) {
        let a = CustomIOSAlertView()
        a?.containerView = NoteView.new(for: lift)
        a?.delegate = self
        a?.show()
    }
    func customIOS7dialogButtonTouchUp(inside alertView: Any!, clickedButtonAt buttonIndex: Int) {
        let av = alertView as! CustomIOSAlertView
        if let nv = av.containerView as? NoteView<Set> {
            RLM.write {
                nv.type.note = nv.textView.text
            }
        } else if let nv = av.containerView as? NoteView<Lift> {
            RLM.write {
                nv.type.note = nv.textView.text
            }
        }
        av.close()
    }
}
