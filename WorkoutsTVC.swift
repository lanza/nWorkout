import UIKit

extension WorkoutsTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "WorkoutsTVC" }
}

class WorkoutsTVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: WorkoutsDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = WorkoutsDataSource(tableView: tableView)
    }
    
    
}
