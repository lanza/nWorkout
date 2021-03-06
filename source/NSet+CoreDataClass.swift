import CoreData
import Foundation

@objc(NSet)
public class NSet: NSManagedObject {

  @nonobjc public class func getFetchRequest() -> NSFetchRequest<NSet> {
    return fetchRequest()
  }

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
    let set = NSet(context: coreDataStack.getContext())
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

  static func makeDummy(lift: NLift) -> NSet {
    let reps = Int.random(in: 0...10)
    let weight = Int64.random(in: 0...100)

    let completedReps = reps - Int.random(in: 0...2)
    let completedWeight = Double(weight)

    let s = NSet.new(
      isWarmup: false, weight: Double(weight), reps: reps,
      completedWeight: completedWeight, completedReps: completedReps, lift: lift
    )
    return s
  }

  static func createFromJSet(_ jset: JSet, in nlift: NLift, at index: Int)
    -> NSet
  {
    let ns = NSet.new(
      isWarmup: jset.isWarmup, weight: jset.weight, reps: jset.reps,
      completedWeight: jset.completedWeight, completedReps: jset.completedReps,
      lift: nlift)
    ns.note = jset.note
    ns.index = Int64(index)
    return ns
  }

  func convertToJSet(in jlift: JLift) -> JSet {
    let jset = JSet.new(
      isWorkout: true, isWarmup: isWarmup, weight: weight, reps: Int(reps),
      completedWeight: completedWeight, completedReps: Int(completedReps),
      lift: jlift)
    jset.note = note ?? ""
    return jset
  }
}
