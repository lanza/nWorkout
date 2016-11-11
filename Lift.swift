import Foundation
import RealmSwift

class Lift: Base {
    dynamic var name = ""
    let sets = List<Set>()
}




extension Lift: DataProvider {
    func append(_ object: Set) {
        sets.append(object)
    }

    func numberOfItems() -> Int {
        return sets.count
    }
    func object(at index: Int) -> Set {
        return sets[index]
    }
    func index(of object: Set) -> Int? {
        return sets.index(of: object)
    }
    func insert(_ object: Set, at index: Int) {
        sets.insert(object, at: index)
    }
    func remove(at index: Int) {
        sets.remove(objectAtIndex: index)
    }
}


