import Foundation
import RealmSwift

class Set: Base {
    dynamic var weight: Double = 0
    dynamic var reps = 0
    dynamic var isWarmup = false
    dynamic var completedWeight: Double = 0
    dynamic var completedReps = 0
}

extension Set {
    func makeWorkoutSet() -> Set {
        let set = Set()
        set.weight = weight
        set.reps = reps
        set.isWarmup = isWarmup
        set.completedWeight = completedWeight
        set.completedReps = completedReps
        set.isWorkout = true
        
        return set
    }
}
