import Foundation

class JLift: Codable, Identifiable {
  var note = ""
  var isWorkout = false
  var name = ""
  weak var workout: JWorkout?
  var sets: [JSet] = []
  var _previousStrings: String = ""

  let id = UUID()

  var previousStrings: [String] {
    return _previousStrings.components(separatedBy: ",")
  }

  static func new(isWorkout: Bool, name: String, workout: JWorkout) -> JLift {
    let lift = JLift()

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

extension JLift {
  func makeWorkoutLift(workout: JWorkout) -> JLift {
    let lift = JLift.new(isWorkout: true, name: name, workout: workout)

    for set in sets {
      let new = set.makeWorkoutSet(lift: self)
      lift.sets.append(new)
    }

    return lift
  }
}

extension JLift: DataProvider {
  func append(_ object: JSet) {
    sets.append(object)
    object.lift = self
  }

  func numberOfItems() -> Int {
    return sets.count
  }

  func object(at index: Int) -> JSet {
    return sets[index]
  }

  func index(of object: JSet) -> Int? {
    return nil
    //    return sets.index(of: object)
  }

  func insert(_ object: JSet, at index: Int) {
    sets.insert(object, at: index)
  }

  func remove(at index: Int) {
    sets.remove(at: index)
  }
}

extension JLift {

  static func makeDummy(name: String = "Riley Feeding") -> JLift {
    let l = JLift()
    l.name = name
    l._previousStrings = "IDK"
    l.isWorkout = true
    l.note = ""
    return l
  }
}
