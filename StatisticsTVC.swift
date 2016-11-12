import UIKit

extension StatisticsTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "StatisticsTVC" }
}

class StatisticsTVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: StatisticsDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = StatisticsDataSource(tableView: tableView)
    }

}
