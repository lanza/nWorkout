import Foundation

class NewWorkout: Codable {
  var note = ""
  var isWorkout = false
  var lifts: [NewLift] = []
  var name = ""
  var isComplete = false
  var startDate = Date()
  var finishDate: Date? = nil
  
  
  public enum CodingKeys: String, CodingKey {
    case note
    case isWorkout
    case name
    case isComplete
    case lifts
    case startDate
    case finishDate
  }
  
  var activeOrFinished: ActiveOrFinished {
    return isComplete ? .finished : .active
  }

  func addNewSet(for lift: NewLift) -> NewSet {
    let last = lift.sets.last
    let set = NewSet.new(
      isWorkout: isWorkout,
      isWarmup: false,
      weight: last?.weight ?? 45,
      reps: last?.reps ?? 6,
      completedWeight: 0,
      completedReps: 0,
      lift: lift
    )
    lift.sets.append(set)
    return set
  }

  func addNewLift(name: String) -> NewLift {
    let lift = NewLift.new(isWorkout: isWorkout, name: name, workout: self)
    lifts.append(lift)
    return lift
  }

  static func new(isWorkout: Bool, isComplete: Bool, name: String) -> NewWorkout {
    let workout = NewWorkout()
    workout.name = name
    workout.isWorkout = isWorkout
    workout.isComplete = isComplete
    JDB.addWorkout(workout)
    return workout
  }

  func deleteSelf() {
    fatalError("This just needs to be removed from JDB array")
  }
}

extension NewWorkout {
  func makeWorkoutWorkout() -> NewWorkout {
    let workout = NewWorkout.new(isWorkout: true, isComplete: false, name: name)

    for lift in lifts {
      let new = lift.makeWorkoutLift(workout: workout)
      workout.lifts.append(new)
    }
    return workout
  }
}

extension NewWorkout: DataProvider {
  func append(_ object: NewLift) {
    lifts.append(object)
  }

  func numberOfItems() -> Int {
    return lifts.count
  }

  func object(at index: Int) -> NewLift {
    return lifts[index]
  }

  func index(of object: NewLift) -> Int? {
    return lifts.firstIndex(where: { $0 === object })
  }

  func insert(_ object: NewLift, at index: Int) {
    lifts.insert(object, at: index)
  }

  func remove(at index: Int) {
    let lift = object(at: index)
    lifts.remove(at: index)
    lift.deleteSelf()
  }

  func move(from sourceIndex: Int, to destinationIndex: Int) {
    let lift = lifts[sourceIndex]
    lifts.remove(at: sourceIndex)
    lifts.insert(lift, at: destinationIndex)
  }

}