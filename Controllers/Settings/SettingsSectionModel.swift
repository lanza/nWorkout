import RxDataSources
import UIKit

enum SettingsSectionsModel {
  case top
  case cells(items: [String])
}
extension SettingsSectionsModel: AnimatableSectionModelType {
  var identity: String {
    switch self {
    case .top: return "top"
    case .cells(items: _): return "cells"
    }
  }

  typealias Item = String

  var items: [String] {
    switch self {
    case .top:
      return [
        "Hide completed reps and weight until the fail button was tapped?",
      ]
    case .cells(items: let strings):
      return strings
    }
  }

  init(original: SettingsSectionsModel, items: [String]) {
    switch original {
    case .top:
      self = .top
    case .cells(_):
      self = .cells(items: items)
    }
  }
}
