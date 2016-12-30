import UIKit
import RxCocoa
import RxSwift
import RealmSwift
import DZNEmptyDataSet

class RoutinesTVC: BaseWorkoutsTVC<RoutineCell> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        workouts = RLM.realm.objects(Workout.self).filter("isWorkout = false").sorted(byProperty: "name")
        
        dataSource = WorkoutsDataSource(tableView: tableView, workouts: workouts)
        dataSource.name = "Routine"
        dataSource.displayAlert = { alert in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {
            let alert = UIAlertController.alert(title: "Create new Routine", message: nil)
            
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routine = dataSource.provider.object(at: indexPath.row)
        delegate!.routinesTVC(self, didSelectRoutine: routine)
    }
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

extension RoutinesTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {}









