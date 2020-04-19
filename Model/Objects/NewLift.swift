import Foundation

class NewLift: Codable {
  var note = ""
  var isWorkout = false
  var name = ""
  var workout: NewWorkout? = nil
  var sets: [NewSet] = []
  var _previousStrings: String = ""

  var previousStrings: [String] {
    return _previousStrings.components(separatedBy: ",")
  }

  static func new(isWorkout: Bool, name: String, workout: NewWorkout) -> NewLift
  {
    let lift = NewLift()

    lift.isWorkout = isWorkout
    lift.name = name
    lift.workout = workout
    if lift.isWorkout {
      lift._previousStrings =
        UserDefaults.standard.value(
          forKey: "last" + lift.name
        ) as? String
        ?? ""
    }
    return lift
  }

  func deleteSelf() {
    fatalError("Just remove it from the array.")
  }

  public enum CodingKeys: String, CodingKey {
    case name
    case sets
    case _previousStrings
  }
}

extension NewLift {
  func makeWorkoutLift(workout: NewWorkout) -> NewLift {
    let lift = NewLift.new(isWorkout: true, name: name, workout: workout)

    for set in sets {
      let new = set.makeWorkoutSet(lift: self)
      lift.sets.append(new)
    }

    return lift
  }
}

extension NewLift: DataProvider {
  func append(_ object: NewSet) {
    sets.append(object)
  }

  func numberOfItems() -> Int {
    return sets.count
  }

  func object(at index: Int) -> NewSet {
    return sets[index]
  }

  func index(of object: NewSet) -> Int? {
    return nil
    //    return sets.index(of: object)
  }

  func insert(_ object: NewSet, at index: Int) {
    sets.insert(object, at: index)
  }

  func remove(at index: Int) {
    sets.remove(at: index)
  }
}
