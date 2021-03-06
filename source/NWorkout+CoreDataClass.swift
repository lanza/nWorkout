import CoreData
import Foundation

@objc(NWorkout)
public class NWorkout: NSManagedObject, DataProvider {

  @nonobjc public class func getFetchRequest() -> NSFetchRequest<NWorkout> {
    return NSFetchRequest<NWorkout>(entityName: "NWorkout")
  }

  static func new(isComplete: Bool = false, name: String) -> NWorkout {
    let workout = NWorkout(context: coreDataStack.getContext())
    workout.startDate = Date()
    workout.name = name
    workout.isComplete = isComplete
    return workout
  }

  func addNewSet(for lift: NLift) -> NSet {
    let sets = lift.getOrderedSets()
    let last = sets.last
    let set = NSet(context: coreDataStack.getContext())
    set.isWarmup = false
    set.weight = last?.weight ?? 45
    set.reps = last?.reps ?? 6
    set.completedWeight = 0
    set.completedReps = 0
    set.lift = lift
    set.index = Int64(sets.count)
    lift.addToSets(set)
    return set
  }

  func isDuplicate(of other: NWorkout) -> Bool {
    return self.startDate == other.startDate
      && self.finishDate == other.finishDate
      && self.name == other.name && self.isComplete == other.isComplete
      && self.lifts!.count == other.lifts!.count && self.note == other.note
  }

  func makeWorkoutWorkout() -> NWorkout {
    let workout = NWorkout(context: coreDataStack.getContext())
    workout.isComplete = false
    workout.name = name
    workout.startDate = Date()

    for l in lifts! {
      let lift = l as! NLift
      let new = lift.makeWorkoutLift(workout: workout)
      workout.addToLifts(new)
    }
    return workout
  }

  func deleteSelf() {
    coreDataStack.getContext().delete(self)
  }

  static func createfromJWorkout(_ jworkout: JWorkout) -> NWorkout {
    let nw = NWorkout.new(name: jworkout.name)
    nw.finishDate = jworkout.finishDate
    nw.isComplete = jworkout.isComplete
    nw.note = jworkout.note
    nw.startDate = jworkout.startDate
    for (index, jlift) in jworkout.lifts.enumerated() {
      nw.addToLifts(NLift.createFromJLift(jlift, in: nw, at: index))
    }
    return nw
  }

  func convertToJWorkout() -> JWorkout {
    let jworkout = JWorkout.new(
      isWorkout: true, isComplete: isComplete, name: name ?? "")
    jworkout.note = note ?? ""

    for lift in getLiftsSorted() {
      jworkout.append(lift.convertToJLift(in: jworkout))
    }

    jworkout.startDate = startDate!
    jworkout.finishDate = finishDate

    return jworkout
  }

  func append(_ object: NLift) {
    addToLifts(object)
  }

  func numberOfItems() -> Int {
    return lifts!.count
  }

  func getLiftsSorted() -> [NLift] {
    return (lifts!.map { $0 } as! [NLift]).sorted(by: { $0.index < $1.index })
  }

  func object(at index: Int) -> NLift {
    return getLiftsSorted()[index]
  }

  func index(of object: NLift) -> Int? {
    return getLiftsSorted().firstIndex(of: object)
  }

  func updateIndices(for lifts: [NLift]) {
    for (index, lift) in lifts.enumerated() {
      lift.index = Int64(index)
    }
  }

  func insert(_ object: NLift, at index: Int) {
    var elements = getLiftsSorted()
    elements.insert(object, at: index)
    updateIndices(for: elements)
    addToLifts(object)
  }

  func remove(at index: Int) {
    var elements = getLiftsSorted()
    let ele = elements.remove(at: index)
    updateIndices(for: elements)
    removeFromLifts(ele)
  }

  func move(from sourceIndex: Int, to destinationIndex: Int) {
    var elements = getLiftsSorted()
    let removed = elements.remove(at: sourceIndex)
    elements.insert(removed, at: destinationIndex)
    updateIndices(for: elements)
  }

  static func makeDummy(name: String = "Dog Petting Session") -> NWorkout {
    let w = NWorkout.new(name: name)
    w.startDate =
      Date() - Date(timeIntervalSinceNow: -1000).timeIntervalSinceNow
    w.finishDate = Date()
    return w
  }

  func addNewLift(name: String) -> NLift {
    let lift = NLift.new(name: name, workout: self)
    lift.index = Int64(lifts!.count)
    addToLifts(lift)
    return lift
  }
}
