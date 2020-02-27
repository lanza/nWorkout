import Foundation
import RealmSwift

class Base: Object, Encodable {
  @objc dynamic var note = ""
  @objc dynamic var isWorkout = false

  func deleteSelf() {

  }

  private enum CodingKeys: String, CodingKey {
    case note
    case isWorkout
  }
}
