import UIKit

extension StatisticsTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "StatisticsTVC" }
}

class StatisticsTVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: StatisticsDataSource!
    let lifts = RLM.realm.objects(Lift.self).filter("isWorkout = true")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = StatisticsDataSource(tableView: tableView, lifts: lifts)
    }

}
