import Foundation
import RealmSwift

class Workout: Base {
    let lifts = List<Lift>()
    dynamic var name = ""
    dynamic var isComplete = false
    dynamic var startDate = Date()
    dynamic var finishDate: Date? = nil
}

extension Workout: DataProvider {
    func append(_ object: Lift) {
        lifts.append(object)
    }

    func numberOfItems() -> Int {
        return lifts.count
    }
    func object(at index: Int) -> Lift {
        return lifts[index]
    }
    func index(of object: Lift) -> Int? {
        return lifts.index(of: object)
    }
    func insert(_ object: Lift, at index: Int) {
        lifts.insert(object, at: index)
    }
    func remove(at index: Int) {
        lifts.remove(objectAtIndex: index)
    }
}
