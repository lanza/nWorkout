import UIKit
import RealmSwift

class WorkoutsDataSource<Cell: UITableViewCell> : DataSource<BaseDataProvider<Workout>,Cell> where Cell: ConfigurableCell, Cell.Object == Workout, Cell: ReusableView {
    
    
    
    var name: String!
    
    init(tableView: UITableView, workouts: Results<Workout>) {
        let provider = BaseDataProvider(objects: workouts)
        super.init(tableView: tableView, provider: provider)
    }
    
    override func initialSetup() {
        super.initialSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { fatalError() }
        let strings = Lets.deleteConfirmationFor(name: name)
        let alert = UIAlertController(title: strings.title, message: strings.message, preferredStyle: .alert)
        let yes = UIAlertAction(title: Lets.yes, style: .default) { _ in
            self.deleteWorkout(at: indexPath)
        }
        let no = UIAlertAction(title: Lets.no, style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        displayAlert(alert)
    }
    
    var displayAlert: ((UIAlertController) -> ())!

    func deleteWorkout(at indexPath: IndexPath) {
        provider.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if provider.numberOfItems() == 0 {
            tableView.reloadData()
        }
    }
}
    
