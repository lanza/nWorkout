import Foundation
import RealmSwift

class Base: Object {
    dynamic var note = ""
    dynamic var isWorkout = false
    
    func deleteSelf() {
        RLM.write {
            RLM.realm.delete(self)
        }
    }
}
