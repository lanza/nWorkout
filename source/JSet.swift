import Foundation

class JSet: Codable, Identifiable {
  private enum CodingKeys: String, CodingKey {
    case note
    case isWorkout
    case weight
    case reps
    case isWarmup
    case completedWeight
    case completedReps
  }

  var note = ""
  var isWorkout = false
  var weight: Double = 0
  var reps = 0
  var isWarmup = false

  let id = UUID()

  var completedWeight: Double = 0
  var completedReps = 0

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
    lift: JLift
  ) -> JSet {
    let set = JSet()

    set.isWorkout = isWorkout
    set.isWarmup = isWarmup
    set.weight = weight
    set.reps = reps
    set.completedWeight = completedWeight
    set.completedReps = completedReps
    set.lift = lift

    return set
  }

  weak var lift: JLift?

  static func makeDummy() -> JSet {
    let s = JSet()

    let reps = Int.random(in: 0...10)
    let weight = Int.random(in: 0...100)

    s.reps = reps
    s.weight = Double(weight)

    s.completedReps = reps - Int.random(in: 0...2)
    s.completedWeight = Double(weight)

    return s
  }
}

extension JSet {
  func makeWorkoutSet(lift: JLift) -> JSet {
    let set = JSet.new(
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

extension JSet {
  func setTarget(weight: Double, reps: Int) {
    self.weight = weight
    self.reps = reps
  }

  func setCompleted(weight: Double, reps: Int) {
    self.completedWeight = weight
    self.completedReps = reps
  }
}
