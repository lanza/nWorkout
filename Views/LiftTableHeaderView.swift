import ChartView
import UIKit

class LiftTableHeaderView: UIView {
  required init?(coder aDecoder: NSCoder) { fatalError() }

  var liftTableHeaderRowView: LiftTableHeaderRowView!

  init(type: LiftTableHeaderRowView.HeaderType) {
    switch type {
    case .routine:
      liftTableHeaderRowView = LiftTableHeaderRowView(type: .routine)
    case .workout:
      liftTableHeaderRowView = LiftTableHeaderRowView(type: .workout)
    case .statisticsHistory:
      liftTableHeaderRowView = LiftTableHeaderRowView(type: .statisticsHistory)
    }
    super.init(frame: .zero)

    setBorder(color: Theme.Colors.Table.borders, width: 1, radius: 0)
    backgroundColor = .darkGray
    setupViews()
  }

  func setupViews() {
    addSubview(liftTableHeaderRowView)
    liftTableHeaderRowView.translatesAutoresizingMaskIntoConstraints = false
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    liftTableHeaderRowView.frame = CGRect(
      x: 1,
      y: 1,
      width: frame.width - 2,
      height: frame.height - 2
    )
  }
}
