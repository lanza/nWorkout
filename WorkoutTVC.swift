import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet

class WorkoutTVC: BaseWorkoutTVC<WorkoutLiftCell> {
    
    var activeOrFinished: ActiveOrFinished { return workout.activeOrFinished }
    
    override func setDataSource() {
        dataSource = WorkoutDataSource(tableView: tableView, provider: workout, activeOrFinished: activeOrFinished)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.cancelWorkoutButton.rx.tap.subscribe(onNext: {
            self.didCancelWorkout()
        }).addDisposableTo(db)
        dataSource.finishWorkoutButtoon.rx.tap.subscribe(onNext: {
            self.didFinishWorkout()
        }).addDisposableTo(db)
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
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
}




