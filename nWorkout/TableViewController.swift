import UIKit
import ChartView
import RealmSwift

class TableViewController<OuterSource: DataProvider, OuterType: DataProvider, OuterCell: ChartViewCell>: UITableViewController where OuterSource.Object == OuterType {
    
    var outerSource: OuterSource
    
    init(outerSource: OuterSource) {
        self.outerSource = outerSource
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.register(OuterCell.self, forCellReuseIdentifier: "cell")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outerSource.numberOfItems()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OuterCell
        let outerElement = outerSource.object(at: indexPath.row)
        cell.chartView.numberOfRows = outerElement.numberOfItems()
        cell.chartView.setup()
        return cell
    }
}


