import Foundation
import RealmSwift

class Set: Base {
    dynamic var weight: Double = 0
    dynamic var reps = 0
    dynamic var isWarmup = false
    dynamic var completedWeight: Double = 0
    dynamic var completedReps = 0
    
    var isComplete: Bool { return weight == completedWeight && reps == completedReps }
    var didFail: Bool { return (completedReps > 0 && completedReps < reps) ||  (completedReps != 0 && completedWeight != 0 && !isComplete) }
    
    static func new(isWorkout: Bool, isWarmup: Bool, weight: Double, reps: Int, completedWeight: Double, completedReps: Int) -> Set {
        let set = Set()
        
        RLM.write {
            set.isWorkout = isWorkout
            set.isWarmup = isWarmup
            set.weight = weight
            set.reps = reps
            set.completedWeight = completedWeight
            set.completedReps = completedReps
            RLM.realm.add(set)
        }
        
        return set
    }
}

extension Set {
    func makeWorkoutSet() -> Set {
        let set = Set.new(isWorkout: true, isWarmup: isWarmup, weight: weight, reps: reps, completedWeight: 0, completedReps: 0)
        
        return set
    }
    
    func failureWeight() -> Double {
        return weight
    }
}
