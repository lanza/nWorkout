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
    
    var keyboardHandler: KeyboardHandler!
    
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
            
            defaultInsets = tableView.contentInset

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
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


