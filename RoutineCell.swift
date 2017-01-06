import Foundation

class RoutineCell: WorkoutCell {
    
    override func setupChartView() {
        super.setupChartView()
        
        chartView.emptyText = "This routine is empty"
    }
    
    override func configure(for object: Workout, at indexPath: IndexPath) {
        super.configure(for: object, at: indexPath)
        label.text = object.name
    }
}
