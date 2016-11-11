import UIKit

class WorkoutsDataSource: DataSource<WorkoutsDataProvider,WorkoutCell> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView, provider: WorkoutsDataProvider())
    }
    
    override func initialSetup() {
        super.initialSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
}
