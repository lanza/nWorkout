import Foundation
import RealmSwift

class Workout: Base {
    let lifts = List<Lift>()
    dynamic var name = ""
    dynamic var isComplete = false
    var activeOrFinished: ActiveOrFinished {
        return isComplete ? .finished : .active
    }
    dynamic var finishDate: Date? = nil
    
    func addNewSet(for lift: Lift) -> Set {
        let set = Set()
        RLM.write {
            set.isWorkout = isWorkout
            let last = lift.sets.last
            set.weight = last?.weight ?? 45
            set.reps = last?.reps ?? 6
            lift.sets.append(set)
        }
        return set
    }
    func addNewLift(name: String) -> Lift {
        let lift = Lift.new(isWorkout: isWorkout, name: name)
        RLM.write {
            lifts.append(lift)
        }
        return lift
    }
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
        return lifts[index]
    }
    func index(of object: Lift) -> Int? {
        return lifts.index(of: object)
    }
    func insert(_ object: Lift, at index: Int) {
        lifts.insert(object, at: index)
    }
    func remove(at index: Int) {
        let lift = lifts[index]
        RLM.write {
            lifts.remove(objectAtIndex: index)
            RLM.realm.delete(lift)
        }
    }
    func move(from sourceIndex: Int, to destinationIndex: Int) {
        let lift = lifts[sourceIndex]
        RLM.write {
            lifts.remove(objectAtIndex: sourceIndex)
            lifts.insert(lift, at: destinationIndex)
        }
    }
    
}

