import UIKit

class WorkoutsTVC: TableViewController<WorkoutsDataProvider,Workout,WorkoutCell> {
    init() {
        super.init(outerSource: WorkoutsDataProvider())
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! WorkoutCell
        
        for (index,label) in cell.labels.enumerated() {
            let item = outerSource.object(at: indexPath.row).object(at: index)
            label.text = item.name + " - \(item.sets.count) sets"
        }
        
        return cell
    }
}
