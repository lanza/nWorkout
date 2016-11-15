import UIKit
import RealmSwift

class StatisticsDataSource: DataSource<BaseDataProvider<Lift>,StatisticsCell> {
    init(tableView: UITableView, lifts: Results<Lift>) {
        super.init(tableView: tableView, provider: BaseDataProvider<Lift>(objects: lifts))
    }
    
    override func initialSetup() {
        super.initialSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
}

class StatisticsCell: UITableViewCell {
    
}

extension StatisticsCell: ConfigurableCell {
    static var identifier: String { return "StatisticsCell" }
    func configure(for object: Lift, at indexPath: IndexPath) {
        textLabel?.text = object.name
    }
}
