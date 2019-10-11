import Foundation
import RealmSwift

class Workout: Base, Encodable {
  let lifts = List<Lift>()
  @objc dynamic var name = ""
  @objc dynamic var isComplete = false

  var activeOrFinished: ActiveOrFinished {
    return isComplete ? .finished : .active
  }

  @objc dynamic var startDate = Date()
  @objc dynamic var finishDate: Date? = nil

  func addNewSet(for lift: Lift) -> Set {
    let last = lift.sets.last
    let set = Set.new(
      isWorkout: isWorkout,
      isWarmup: false,
      weight: last?.weight ?? 45,
      reps: last?.reps ?? 6,
      completedWeight: 0,
      completedReps: 0,
      lift: lift
    )
    RLM.write {
      lift.sets.append(set)
    }
    return set
  }

  func addNewLift(name: String) -> Lift {
    let lift = Lift.new(isWorkout: isWorkout, name: name, workout: self)
    RLM.write {
      lifts.append(lift)
    }
    return lift
  }

  static func new(isWorkout: Bool, isComplete: Bool, name: String) -> Workout {
    let workout = Workout()
    RLM.write {
      workout.name = name
      workout.isWorkout = isWorkout
      workout.isComplete = isComplete
      RLM.realm.add(workout)
    }
    return workout
  }

  override func deleteSelf() {
    for lift in lifts {
      lift.deleteSelf()
    }
    super.deleteSelf()
  }
}

extension Workout {
  func makeWorkoutWorkout() -> Workout {
    let workout = Workout.new(isWorkout: true, isComplete: false, name: name)

    for lift in lifts {
      let new = lift.makeWorkoutLift(workout: workout)
      RLM.write {
        workout.lifts.append(new)
      }
    }
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
    let lift = object(at: index)
    RLM.write {
      lifts.remove(at: index)
    }
    lift.deleteSelf()
  }

  func move(from sourceIndex: Int, to destinationIndex: Int) {
    let lift = lifts[sourceIndex]
    RLM.write {
      lifts.remove(at: sourceIndex)
      lifts.insert(lift, at: destinationIndex)
    }
  }

}
