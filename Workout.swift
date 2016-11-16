import Foundation
import RealmSwift

class Workout: Base {
    let lifts = List<Lift>()
    dynamic var name = ""
    dynamic var isComplete = false
    dynamic var finishDate: Date? = nil
}

extension Workout {
    func makeWorkoutWorkout() -> Workout {
        let workout = Workout()
        
        for lift in lifts {
            workout.lifts.append(lift.makeWorkoutLift())
        }
        workout.name = name
        workout.isComplete = false
        workout.isWorkout = true
        
        return workout
    }
}

extension Workout: DataProvider {
    func append(_ object: Lift) {
        lifts.append(object)
    }

    func numberOfItems() -> Int {
        return lifts.count
    }
    func object(at index: Int) -> Lift {
        print("Workout")
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
