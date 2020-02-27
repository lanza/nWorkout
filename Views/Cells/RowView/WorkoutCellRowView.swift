import UIKit

class WorkoutCellRowView: RowView {
  required init() {
    super.init()

    columnBackgroundColor = Theme.Colors.Cell.contentBackground

    columnViewTypes = [DarkLabel.self, DarkLabel.self]
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}
