import UIKit

extension WorkoutTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "WorkoutTVC" }
}

class WorkoutTVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: WorkoutDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = WorkoutDataSource(tableView: tableView)
    }
}
