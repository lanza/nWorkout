import UIKit

class StatisticsHistorySetRowView: RowView {
  required init() {
    super.init()
    columnViewTypes = [
      DarkLabel.self, DarkLabel.self, DarkLabel.self, DarkLabel.self,
    ]
    columnWidths = [25, 25, 25, 25]
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}
