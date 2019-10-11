import Foundation
import RealmSwift

class Base: Object {
  @objc dynamic var note = ""
  @objc dynamic var isWorkout = false

  func deleteSelf() {
    RLM.write {
      RLM.realm.delete(self)
    }
  }
}
