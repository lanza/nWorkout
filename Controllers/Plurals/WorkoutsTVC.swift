import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import BonMot

class WorkoutsTVC: BaseWorkoutsTVC<WorkoutCell> {
    
    func setTableHeaderView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        let label = UILabel()
        label.text = "History"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        tableView.tableHeaderView = view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        workouts = RLM.realm.objects(Workout.self).filter("isWorkout = true").filter("isComplete = true").sorted(byKeyPath: "startDate", ascending: false)
        
        dataSource = WorkoutsDataSource(tableView: tableView, workouts: workouts)
        dataSource.name = Lets.workout
        dataSource.displayAlert = { alert in
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        setTableHeaderView()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        emptyDataSetController.imageTintColorForEmptyDataSet = .white
        emptyDataSetController.imageForEmptyDataSet = #imageLiteral(resourceName: "workout")
        let s = StringStyle(.color(.white))
        emptyDataSetController.titleForEmptyDataSet = "You have not done any workouts.".styled(with: s)
        emptyDataSetController.descriptionForEmptyDataSet = "Click the + at the bottom to start your first workout or the \"Routines\" tab to set up a routine".styled(with: s)
        
        tableView.emptyDataSetDelegate = emptyDataSetController
        tableView.emptyDataSetSource = emptyDataSetController
    }
   
    let emptyDataSetController = EmptyDataSetController()
    
    
    //mark: - Swift is so fucking stupid
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = workouts[indexPath.row]
        delegate!.workoutsTVC(self, didSelectWorkout: workout)
    }
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "workout")
    }
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let s = StringStyle(.color(.white))
        return "You have not done any workouts".styled(with: s)
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let s = StringStyle(.color(.white))
        return "Click the + at the bottom to start your first workout or the \"Routines\" tab to set up a routine".styled(with: s)
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
    
}

extension WorkoutsTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {}
