import Foundation
import RealmSwift

class Base: Object, Encodable {
  @objc dynamic var note = ""
  @objc dynamic var isWorkout = false

  func deleteSelf() {
    RLM.write {
      RLM.realm.delete(self)
    }
  }

  private enum CodingKeys: String, CodingKey {
    case note
    case isWorkout
  }
}
