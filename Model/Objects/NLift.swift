import Foundation

class NLift: Codable, Identifiable {
  var note = ""
  var isWorkout = false
  var name = ""
  weak var workout: NWorkout?
  var sets: [NSet] = []
  var _previousStrings: String = ""

  let id = UUID()

  var previousStrings: [String] {
    return _previousStrings.components(separatedBy: ",")
  }

  static func new(isWorkout: Bool, name: String, workout: NWorkout) -> NLift
  {
    let lift = NLift()

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

extension NLift {
  func makeWorkoutLift(workout: NWorkout) -> NLift {
    let lift = NLift.new(isWorkout: true, name: name, workout: workout)

    for set in sets {
      let new = set.makeWorkoutSet(lift: self)
      lift.sets.append(new)
    }

    return lift
  }
}

extension NLift: DataProvider {
  func append(_ object: NSet) {
    sets.append(object)
    object.lift = self
  }

  func numberOfItems() -> Int {
    return sets.count
  }

  func object(at index: Int) -> NSet {
    return sets[index]
  }

  func index(of object: NSet) -> Int? {
    return nil
    //    return sets.index(of: object)
  }

  func insert(_ object: NSet, at index: Int) {
    sets.insert(object, at: index)
  }

  func remove(at index: Int) {
    sets.remove(at: index)
  }
}
