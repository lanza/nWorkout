import Foundation
import RealmSwift

class Lift: Base {
    dynamic var name = ""
    let sets = List<Set>()
    dynamic var _previousStrings: String = ""
    var previousStrings: [String] { return _previousStrings.components(separatedBy: ",") }
    
}

extension Lift {
    func makeWorkoutLift() -> Lift {
        let lift = Lift()
        
        lift.name = name
        for set in sets {
            lift.sets.append(set.makeWorkoutSet())
        }
        lift.isWorkout = true
        
        lift._previousStrings = UserDefaults.standard.value(forKey: "last" + lift.name) as? String ?? ""
        
        return lift
    }
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


