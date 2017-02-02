import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import BonMot

class RoutineTVC: BaseWorkoutTVC<RoutineLiftCell> {
    
    override func setDataSource() {
        dataSource = WorkoutDataSource(tableView: tableView, provider: workout, activeOrFinished: .finished)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = workout.name
    }

    override func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "routine")
    }
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let s = StringStyle(.color(.white))
        return "You have not added any lifts, yet!".styled(with: s)
    }
    override func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let s = StringStyle(.color(.white))
        return "Click \"Add Lift\" to add a new exercise to your Routine.".styled(with: s)
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
}
