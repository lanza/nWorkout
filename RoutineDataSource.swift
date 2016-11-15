import UIKit

class RoutineDataSource: DataSource<Workout,RoutineLiftCell> {
    
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
            let cell = super.tableView(tableView, cellForRowAt: indexPath) as! RoutineLiftCell
            
            let lift = provider.object(at: indexPath.row)
            
            cell.addSetButton.rx.tap.subscribe(onNext: {
                let set = Set()
                RLM.write {
                    DispatchQueue.main.async {
                        self.tableView.beginUpdates()
                    }
                    set.weight = 225
                    set.reps = 5
                    lift.sets.append(set)
                    DispatchQueue.main.async {
                        cell.chartView.setup()
                        self.tableView.endUpdates()
                    }
                }
            }).addDisposableTo(cell.db)
            return cell
        }
    }
}
