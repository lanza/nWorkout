import UIKit

extension RoutinesTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "RoutinesTVC" }
}

class RoutinesTVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource: RoutinesDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = RoutinesDataSource(tableView: tableView)
    }
    
    
}
