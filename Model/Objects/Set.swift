import Foundation
import RealmSwift

class Set: Base {
  private enum CodingKeys: String, CodingKey {
    case weight
    case reps
    case isWarmup
    case completedWeight
    case completedReps
  }

  override func encode(to encoder: Encoder) throws {
    try super.encode(to: encoder)
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.weight, forKey: .weight)
    try container.encode(self.reps, forKey: .reps)
    try container.encode(self.isWarmup, forKey: .isWarmup)
    try container.encode(self.completedWeight, forKey: .completedWeight)
    try container.encode(self.completedReps, forKey: .completedReps)
  }

  @objc dynamic var weight: Double = 0
  @objc dynamic var reps = 0
  @objc dynamic var isWarmup = false

  @objc dynamic var completedWeight: Double = 0 {
    didSet {
      print(
        "CompletedReps touched - weight: \(weight), reps: \(reps), completedWeight: \(completedWeight), completedReps: \(completedReps)"
      )
    }
  }

  @objc dynamic var completedReps = 0 {
    didSet {
      print(
        "CompletedWeight touched - weight: \(weight), reps: \(reps), completedWeight: \(completedWeight), completedReps: \(completedReps)"
      )
    }
  }

  var isComplete: Bool {
    return weight == completedWeight && reps == completedReps
  }

  var isFresh: Bool { return completedWeight == 0 && completedReps == 0 }
  var didFail: Bool { return !isComplete && !isFresh }

  static func new(
    isWorkout: Bool,
    isWarmup: Bool,
    weight: Double,
    reps: Int,
    completedWeight: Double,
    completedReps: Int,
    lift: Lift
  ) -> Set {
    let set = Set()

    RLM.write {
      set.isWorkout = isWorkout
      set.isWarmup = isWarmup
      set.weight = weight
      set.reps = reps
      set.completedWeight = completedWeight
      set.completedReps = completedReps
      set.lift = lift
      RLM.realm.add(set)
    }

    return set
  }

  @objc dynamic var lift: Lift?
}

extension Set {
  func makeWorkoutSet(lift: Lift) -> Set {
    let set = Set.new(
      isWorkout: true,
      isWarmup: isWarmup,
      weight: weight,
      reps: reps,
      completedWeight: 0,
      completedReps: 0,
      lift: lift
    )
    return set
  }

  var failureWeight: Double { return weight }
}

extension Set {
  func setTarget(weight: Double, reps: Int) {
    RLM.write {
      self.weight = weight
      self.reps = reps
    }
  }

  func setCompleted(weight: Double, reps: Int) {
    RLM.write {
      self.completedWeight = weight
      self.completedReps = reps
    }
  }
}
