import UIKit

class StatisticsDataSource: DataSource<BaseDataProvider<Lift>,StatisticsCell> {
    init(tableView: UITableView) {
        super.init(tableView: tableView, provider: BaseDataProvider<Lift>(isWorkout: true))
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
