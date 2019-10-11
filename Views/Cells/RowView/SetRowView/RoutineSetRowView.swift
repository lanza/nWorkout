import Foundation

class RoutineSetRowView: SetRowView {
  override func setupSelectedColumnViewTypesAndWidth() {
    let i = ViewInfo.routineColumnViewInfo
    selectedColumnViewTypes = i.map { $0.0 }
    selectedColumnViewWidths = i.map { $0.1 }
  }
}
