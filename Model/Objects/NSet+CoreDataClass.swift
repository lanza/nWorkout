import CoreData
import Foundation

@objc(NSet)
public class NSet: NSManagedObject {

  // TODO: This trio of things is really bad -- 0 & 0 can be skipped
  // Though implementing that in UI would have to be a good user experience
  // add a skip button?
  func isComplete() -> Bool {
    return weight == completedWeight && reps == completedReps
  }
  func isFresh() -> Bool { return completedWeight == 0 && completedReps == 0 }
  func didFail() -> Bool { return !isComplete() && !isFresh() }

  static func new(
    isWarmup: Bool,
    weight: Double,
    reps: Int,
    completedWeight: Double,
    completedReps: Int,
    lift: NLift
  ) -> NSet {
    let set = NSet(context: coreDataStack.managedObjectContext)
    set.isWarmup = isWarmup
    set.weight = weight
    set.reps = Int64(reps)
    set.completedWeight = completedWeight
    set.completedReps = Int64(completedReps)
    set.lift = lift

    return set
  }

  func makeWorkoutSet(lift: NLift) -> NSet {
    let set = NSet.new(
      isWarmup: isWarmup,
      weight: weight,
      reps: Int(reps),
      completedWeight: 0,
      completedReps: 0,
      lift: lift
    )
    return set
  }

  func setTarget(weight: Double, reps: Int) {
    self.weight = weight
    self.reps = Int64(reps)
  }

  func setCompleted(weight: Double, reps: Int) {
    self.completedWeight = weight
    self.completedReps = Int64(reps)
  }

  static func makeDummy() -> NSet {
    let s = NSet()

    let reps = Int64.random(in: 0...10)
    let weight = Int64.random(in: 0...100)

    s.reps = reps
    s.weight = Double(weight)

    s.completedReps = reps - Int64.random(in: 0...2)
    s.completedWeight = Double(weight)

    return s
  }
}
