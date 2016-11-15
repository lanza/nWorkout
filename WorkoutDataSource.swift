import UIKit

class WorkoutDataSource: DataSource<Workout,LiftCell> {
    
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
            return 1
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Add Lift"
            cell.textLabel?.textAlignment = .center
            return cell
        } else {
            let cell = super.tableView(tableView, cellForRowAt: indexPath) as! LiftCell
            
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

