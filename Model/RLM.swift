import Foundation
import RealmSwift

enum RLM {
  static let realm = try! Realm()

  static func write(transaction: () -> Void) {
    do {
      try realm.write(transaction)
    } catch let error {
      print(error)
    }
  }

  static func objects<T: Object>(type: T.Type) -> Results<T> {
    return realm.objects(T.self)
  }
}
