import UIKit

class RoutineDataSource: DataSource<Workout,LiftCell> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView, provider: Workout())
    }
    
    override func initialSetup() {
        super.initialSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
}
