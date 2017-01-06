import UIKit

class RoutineLiftCell: LiftCell {
    override func setupChartView() {
        super.setupChartView()
        chartView.register(RoutineSetRowView.self, forResuseIdentifier: "row")
    }
    
    override func setHeader() {
        header = RoutineLiftTableHeaderView()
    }
    
    override func configure(for object: Lift, at indexPath: IndexPath) {
        super.configure(for: object, at: indexPath)
    }
}
