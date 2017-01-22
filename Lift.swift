import Foundation
import RealmSwift

class Lift: Base {
    dynamic var name = ""
    let sets = List<Set>()
    dynamic var _previousStrings: String = ""
    var previousStrings: [String] { return _previousStrings.components(separatedBy: ",") }
    
    static func new(isWorkout: Bool, name: String) -> Lift {
        let lift = Lift()
        
        RLM.write {
            lift.name = name
            lift.isWorkout = isWorkout
            if lift.isWorkout {
                lift._previousStrings = UserDefaults.standard.value(forKey: "last" + lift.name) as? String ?? ""
            }
            RLM.realm.add(lift)
        }
        return lift
    }
    
    override func deleteSelf() {
        for set in sets {
            set.deleteSelf()
        }
        super.deleteSelf()
    }
    
    
    
}

extension Lift {
    func makeWorkoutLift() -> Lift {
        let lift = Lift.new(isWorkout: true, name: name)
        
        for set in sets {
            let new = set.makeWorkoutSet()
            RLM.write {
                lift.sets.append(new)
            }
        }
        
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
        let set = object(at: index)
        RLM.write {
            sets.remove(objectAtIndex: index)
        }
        set.deleteSelf()
    }
}


