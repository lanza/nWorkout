import Foundation
import RealmSwift

class RLM {
    static let realm = try! Realm()
    static func write(transaction: ()->()) {
        do {
            try realm.write(transaction)
        } catch let error {
            print(error)
        }
    }
}
