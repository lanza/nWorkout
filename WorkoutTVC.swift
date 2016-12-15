import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet

class WorkoutTVC: UITableViewController {
    
    var dataSource: WorkoutDataSource!
    var workout: Workout!
    var isActive: Bool { return !workout.isComplete }
    
    var keyboardHandler: KeyboardHandler!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Keyboard.shared.delegate = dataSource.textFieldBehaviorHandler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = WorkoutDataSource(tableView: tableView, provider: workout)
        dataSource.isActive = isActive
        
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
        dataSource.cancelWorkoutButton.rx.tap.subscribe(onNext: {
            self.didCancelWorkout()
        }).addDisposableTo(db)
        dataSource.finishWorkoutButtoon.rx.tap.subscribe(onNext: {
            self.didFinishWorkout()
        }).addDisposableTo(db)
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

extension WorkoutTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
}

class KeyboardHandler: NSObject {
    weak var tableView: UITableView!
    weak var view: UIView!
    static func new(tableView: UITableView, view: UIView) -> KeyboardHandler {
        let kh = KeyboardHandler()
        kh.tableView = tableView
        kh.view = view
        NotificationCenter.default.addObserver(kh, selector: #selector(KeyboardHandler.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(kh, selector: #selector(KeyboardHandler.keyboardDidShow(_: )), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(kh, selector: #selector(KeyboardHandler.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        return kh
    }
    var defaultInsets: UIEdgeInsets!
    var keyboardHeight: CGFloat!
    func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            
            if defaultInsets == nil {
                defaultInsets = tableView.contentInset
            }

            let value = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            keyboardHeight = value?.height ?? view.frame.height * CGFloat(Lets.keyboardToViewRatio)
            
            let insets = UIEdgeInsets(top: defaultInsets.top, left: defaultInsets.left, bottom: keyboardHeight, right: defaultInsets.right)
            
            tableView.contentInset = insets
            tableView.scrollIndicatorInsets = insets
        }
    }
    func keyboardDidShow(_ notification: Notification) {
        scrollToTextField()
    }
    
    func scrollToTextField() {
        if let firstResponder = UIResponder.currentFirstResponder() as? UIView {
            
            let frFrame = firstResponder.frame
            
            let corrected = UIApplication.shared.keyWindow!.convert(frFrame, from: firstResponder.superview)
            let yRelativeToKeyboard = (view.frame.height - keyboardHeight) - (corrected.origin.y + corrected.height)

            if yRelativeToKeyboard < 0 {
                
                let frInViewsFrame = view.convert(frFrame, from: firstResponder.superview)
                let scrollPoint = CGPoint(x: 0, y: frInViewsFrame.origin.y - keyboardHeight - tableView.contentInset.top - frInViewsFrame.height - UIApplication.shared.statusBarFrame.height)
                
                tableView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.2) {
            guard let defaultInsets = self.defaultInsets else { return }
            self.tableView.contentInset = defaultInsets
            self.tableView.scrollIndicatorInsets = defaultInsets
            self.defaultInsets = nil
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


