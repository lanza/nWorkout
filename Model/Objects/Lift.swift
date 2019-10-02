import Foundation
import RealmSwift

class Lift: Base, Encodable {
    @objc dynamic var name = ""
    let sets = List<Set>()
    @objc dynamic var _previousStrings: String = ""
    var previousStrings: [String] { return _previousStrings.components(separatedBy: ",") }
    
    static func new(isWorkout: Bool, name: String, workout: Workout) -> Lift {
        let lift = Lift()
        
        RLM.write {
            lift.isWorkout = isWorkout
            lift.name = name
            lift.workout = workout
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
    
    private enum CodingKeys: String, CodingKey {
        case name
        case sets
    }
    
    @objc dynamic var workout: Workout?
}

extension Lift {
    func makeWorkoutLift(workout: Workout) -> Lift {
        let lift = Lift.new(isWorkout: true, name: name, workout: workout)
        
        for set in sets {
            let new = set.makeWorkoutSet(lift: self)
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
            sets.remove(at: index)
        }
        set.deleteSelf()
    }
}


