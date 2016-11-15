import UIKit

class WorkoutDataSource: DataSource<Workout,WorkoutLiftCell> {
    
    var isActive = false
    
    override func initialSetup() {
        super.initialSetup()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = UITableViewCell()
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Add Lift"
            case 1:
                cell.textLabel?.text = "Cancel Workout"
            case 2:
                cell.textLabel?.text = "Finish Workout"
            default: fatalError()
            }
            cell.textLabel?.textAlignment = .center
            return cell
        } else {
            let cell = super.tableView(tableView, cellForRowAt: indexPath) as! WorkoutLiftCell
            
            let lift = provider.object(at: indexPath.row)
            
            cell.addSetButton.rx.tap.subscribe(onNext: {
                self.tableView.beginUpdates()
                let set = Set()
                RLM.write {
                    set.weight = 225
                    set.reps = 5
                    lift.sets.append(set)
                    cell.chartView.setup()
                }
                self.tableView.endUpdates()
            }).addDisposableTo(cell.db)
            return cell
        }
    }
    
    
}

