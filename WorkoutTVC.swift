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
        
        if activeOrFinished == .active {
            dataSource.cancelWorkoutButton.rx.tap.subscribe(onNext: {
                self.didCancelWorkout()
            }).addDisposableTo(db)
            dataSource.finishWorkoutButtoon.rx.tap.subscribe(onNext: {
                self.didFinishWorkout()
            }).addDisposableTo(db)
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: nil, action: nil)
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




