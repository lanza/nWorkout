import UIKit

class WorkoutTVC: TableViewController<Workout,Lift,LiftCell> {
    init(workout: Workout) {
        super.init(outerSource: workout)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! LiftCell
        
        for (index,(weightTextField,repsTextField)) in (zip(cell.weightTextFields, cell.repsTextFields)).enumerated() {
            let set = outerSource.object(at: indexPath.row).object(at: index)
            weightTextField.text = String(set.weight)
            repsTextField.text = String(set.reps)
        }
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
