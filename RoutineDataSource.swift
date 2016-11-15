import UIKit

class RoutineDataSource: DataSource<Workout,LiftCell> {
    
    override func initialSetup() {
        super.initialSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
}
