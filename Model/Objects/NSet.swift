import Foundation

class NSet: Codable, Identifiable {
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

  var completedWeight: Double = 0 {
    didSet {
      print(
        "CompletedReps touched - weight: \(weight), reps: \(reps), completedWeight: \(completedWeight), completedReps: \(completedReps)"
      )
    }
  }

  var completedReps = 0 {
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
    lift: NLift
  ) -> NSet {
    let set = NSet()

    set.isWorkout = isWorkout
    set.isWarmup = isWarmup
    set.weight = weight
    set.reps = reps
    set.completedWeight = completedWeight
    set.completedReps = completedReps
    set.lift = lift

    return set
  }

  weak var lift: NLift?

  static func makeDummy() -> NSet {
    let s = NSet()

    let reps = Int.random(in: 0...10)
    let weight = Int.random(in: 0...100)

    s.reps = reps
    s.weight = Double(weight)

    s.completedReps = reps - Int.random(in: 0...2)
    s.completedWeight = Double(weight)

    return s
  }
}

extension NSet {
  func makeWorkoutSet(lift: NLift) -> NSet {
    let set = NSet.new(
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

extension NSet {
  func setTarget(weight: Double, reps: Int) {
    self.weight = weight
    self.reps = reps
  }

  func setCompleted(weight: Double, reps: Int) {
    self.completedWeight = weight
    self.completedReps = reps
  }
}
