import UIKit

class WorkoutCellRowView: RowView {
  required init() {
    super.init()

    columnViewTypes = [DarkLabel.self, DarkLabel.self]
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}
