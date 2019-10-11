import UIKit

struct ViewInfo: Equatable {
  static func == (lhs: ViewInfo, rhs: ViewInfo) -> Bool {
    return lhs.name == rhs.name
  }

  var name: String
  var width: CGFloat
  var isOn: Bool

  static func from(array: [Any]) -> ViewInfo {
    return ViewInfo(
      name: array[0] as! String,
      width: array[1] as! CGFloat,
      isOn: array[2] as! Bool
    )
  }

  var array: [Any] {
    return [name, width, isOn]
  }

  private static var all: [ViewInfo] {
    return [
      ViewInfo(name: Lets.setNumberKey, width: 10, isOn: true),
      ViewInfo(name: Lets.previousWorkoutKey, width: 25, isOn: true),
      ViewInfo(name: Lets.targetWeightKey, width: 20, isOn: true),
      ViewInfo(name: Lets.targetRepsKey, width: 20, isOn: true),
      ViewInfo(name: Lets.completedWeightKey, width: 20, isOn: true),
      ViewInfo(name: Lets.completedRepsKey, width: 20, isOn: true),
      ViewInfo(name: Lets.doneButtonKey, width: 20, isOn: true),
      ViewInfo(name: Lets.failButtonKey, width: 8, isOn: true),

      ViewInfo(name: Lets.noteButtonKey, width: 8, isOn: true),
    ]
  }

  private static var defaults: [ViewInfo] {
    return [
      ViewInfo(name: Lets.setNumberKey, width: 10, isOn: true),
      ViewInfo(name: Lets.previousWorkoutKey, width: 25, isOn: true),
      ViewInfo(name: Lets.targetWeightKey, width: 20, isOn: true),
      ViewInfo(name: Lets.targetRepsKey, width: 20, isOn: true),
      ViewInfo(
        name: Lets.doneButtonCompletedWeightCompletedRepsKey,
        width: 20,
        isOn: true
      ),
      ViewInfo(name: Lets.failButtonKey, width: 8, isOn: true),

      ViewInfo(name: Lets.noteButtonKey, width: 8, isOn: true),
    ]
  }

  static var usesCombinedView: Bool {
    return UserDefaults.standard.value(
      forKey: Lets.combineFailAndCompletedWeightAndRepsKey
    )
      as? Bool ?? false
  }

  static func setUsesCombinedView(_ bool: Bool) {
    UserDefaults.standard.set(
      bool,
      forKey: Lets.combineFailAndCompletedWeightAndRepsKey
    )

    var saved = self.saved

    if bool {
      guard
        let completedWeightIndex = saved.index(
          where: { $0.name == Lets.completedWeightKey }
        )
      else { fatalError() }
      saved.remove(at: completedWeightIndex)

      guard
        let completedRepsIndex = saved.index(
          where: { $0.name == Lets.completedRepsKey }
        )
      else {
        fatalError()
      }
      saved.remove(at: completedRepsIndex)

      guard
        let doneButtonIndex = saved.index(
          where: { $0.name == Lets.doneButtonKey }
        )
      else {
        fatalError()
      }
      let doneViewInfo = saved[doneButtonIndex]
      let doneButtonCompletedWeightCompletedRepsViewInfo = ViewInfo(
        name: Lets.doneButtonCompletedWeightCompletedRepsKey,
        width: doneViewInfo.width,
        isOn: true
      )

      saved.replaceSubrange(
        doneButtonIndex...doneButtonIndex,
        with: [doneButtonCompletedWeightCompletedRepsViewInfo]
      )
    }
    else {
      guard
        let combinedIndex = saved.index(
          where: { $0.name == Lets.doneButtonCompletedWeightCompletedRepsKey }
        )
      else { fatalError() }

      let weightViewInfo = ViewInfo(
        name: Lets.completedWeightKey,
        width: 20,
        isOn: true
      )
      let repsViewInfo = ViewInfo(
        name: Lets.completedRepsKey,
        width: 20,
        isOn: true
      )
      let doneViewInfo = ViewInfo(
        name: Lets.doneButtonKey,
        width: 20,
        isOn: true
      )

      saved.replaceSubrange(
        combinedIndex...combinedIndex,
        with: [weightViewInfo, repsViewInfo, doneViewInfo]
      )
    }
    ViewInfo.saveViewInfos(saved)
  }

  static func saveViewInfos(_ viewInfos: [ViewInfo]) {
    UserDefaults.standard.set(
      viewInfos.map { $0.array },
      forKey: Lets.viewInfoKey
    )
  }

  static var saved: [ViewInfo] {
    let stored = (
      UserDefaults.standard.value(forKey: Lets.viewInfoKey) as? [[Any]]
    ).map {
      $0.map { ViewInfo.from(array: $0) }
    }
    return stored ?? ViewInfo.defaults
  }

  static var routineColumnViewInfo: [(String, CGFloat)] {
    return [
      (Lets.setNumberKey, 10), (Lets.targetWeightKey, 45),
      (Lets.targetRepsKey, 45),
    ]
  }

  static var statisticsHistoryColumnViewInfo: [(String, CGFloat)] {
    return [
      (Lets.targetWeightKey, 25), (Lets.targetRepsKey, 25),
      (Lets.completedWeightKey, 25),
      (Lets.completedRepsKey, 25),
    ]
  }
}
