import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet

protocol WorkoutTVCDelegate: class {
    func hideTapped(for workoutTVC: WorkoutTVC)
}

class WorkoutTVC: BaseWorkoutTVC<WorkoutLiftCell> {
    
    weak var delegate: WorkoutTVCDelegate!
    
    var activeOrFinished: ActiveOrFinished { return workout.activeOrFinished }
    
    override func setDataSource() {
        dataSource = WorkoutDataSource(tableView: tableView, provider: workout, activeOrFinished: activeOrFinished)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Lets.workoutStartTimeDF.string(from: workout.startDate)
        
        if activeOrFinished == .active {
            dataSource.cancelWorkoutButton.rx.tap.subscribe(onNext: {
                let a = UIAlertController.confirmAction(title: "Cancel Workout?", message: "Are you sure you want to cancel this workout?") { _ in
                    self.didCancelWorkout()
                }
                self.present(a, animated: true, completion: nil)
            }).addDisposableTo(db)
            dataSource.finishWorkoutButtoon.rx.tap.subscribe(onNext: {
                let a = UIAlertController.confirmAction(title: "Finish Workout?", message: "Are you sure you want to finish this workout?") { _ in
                    self.didFinishWorkout()
                }
                self.present(a, animated: true, completion: nil)
            }).addDisposableTo(db)
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: Lets.hide, style: .plain, target: nil, action: nil)
            navigationItem.leftBarButtonItem!.rx.tap.subscribe(onNext: {
                self.delegate.hideTapped(for: self)
            }).addDisposableTo(db)
        }
    }
    
    var didFinishWorkout: (() -> ())!
    var didCancelWorkout: (() -> ())!
    
    
    override func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "workout")
    }
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "You have not added any lifts, yet!")
    }
    override func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Click \"Add Lift\" to add a new exercise to your Workout.")
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 40
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
}



class NoteView<Type: Base>: UIView {
    var type: Type!
    static func new(for type: Type) -> NoteView {
        let n = NoteView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
        n.type = type
        n.textView.text = n.type.note
        n.setupViews()
        return n
    }
    let textView = UITextView()
    
    func setupViews() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
            ])
    }
}



