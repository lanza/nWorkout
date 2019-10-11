import UIKit

class WorkoutLiftCell: LiftCell {
  override func setupChartView() {
    super.setupChartView()
    chartView.register(SetRowView.self, forResuseIdentifier: "row")
  }
}
