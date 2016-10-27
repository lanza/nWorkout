import Foundation
import RealmSwift

class Set: Base {
    dynamic var weight: Double = 0
    dynamic var reps = 0
    dynamic var isWarmup = false
    dynamic var completedWeight: Double = 0
    dynamic var completedReps: Double = 0
}
