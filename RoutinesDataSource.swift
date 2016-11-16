import UIKit
import RealmSwift

class RoutinesDataSource: DataSource<BaseDataProvider<Workout>,RoutineCell> {
    
    init(tableView: UITableView, workouts: Results<Workout>) {
        let provider = BaseDataProvider(objects: workouts)
        super.init(tableView: tableView, provider: provider)
    }
    
    override func initialSetup() {
        super.initialSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
}
