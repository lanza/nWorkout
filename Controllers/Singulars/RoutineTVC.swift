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
        setupDZN()
    }
    
    
    func setupDZN() {
        emptyDataSetController.imageTintColorForEmptyDataSet = .white
        emptyDataSetController.imageForEmptyDataSet = #imageLiteral(resourceName: "routine")
        let s = StringStyle(.color(.white))
        emptyDataSetController.titleForEmptyDataSet = "You do not have any lifts, yet!.".styled(with: s)
        emptyDataSetController.descriptionForEmptyDataSet = "Click \"Add Lift\" to add a new exerccise to your Routine.".styled(with: s)
        
        tableView.emptyDataSetDelegate = emptyDataSetController
        tableView.emptyDataSetSource = emptyDataSetController
    }
    
    let emptyDataSetController = EmptyDataSetController()
}
