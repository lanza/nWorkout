import CoreData
import Foundation

@objc(NWorkout)
public class NWorkout: NSManagedObject {

  static func new(isComplete: Bool, name: String) -> NWorkout {
    let workout = NWorkout(context: coreDataStack.managedObjectContext)
    workout.name = name
    workout.isComplete = isComplete
    return workout
  }

  func addNewSet(for lift: NLift) -> NSet {
    let last = lift.sets?.lastObject as? NSet

    let set = NSet(context: coreDataStack.managedObjectContext)
    set.isWarmup = false
    set.weight = last?.weight ?? 45
    set.reps = last?.reps ?? 6
    set.completedWeight = 0
    set.completedReps = 0
    set.lift = lift
    lift.addToSets(set)
    return set
  }

  func makeWorkoutWorkout() -> NWorkout {
    let workout = NWorkout(context: coreDataStack.managedObjectContext)
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
    coreDataStack.managedObjectContext.delete(self)
  }
}

extension NWorkout: DataProvider {
  func append(_ object: NLift) {
    addToLifts(object)
  }

  func numberOfItems() -> Int {
    return lifts!.count
  }

  func object(at index: Int) -> NLift {
    return lifts!.object(at: index) as! NLift
  }

  func index(of object: NLift) -> Int? {
    return lifts!.index(of: object)
  }

  func insert(_ object: NLift, at index: Int) {
    insertIntoLifts(object, at: index)
  }

  func remove(at index: Int) {
    removeFromLifts(at: index)
  }

  func move(from sourceIndex: Int, to destinationIndex: Int) {
    let lift = lifts!.object(at: sourceIndex) as! NLift
    removeFromLifts(at: sourceIndex)
    insertIntoLifts(lift, at: destinationIndex)
  }

  static func makeDummy(name: String = "Dog Petting Session") -> NWorkout {
    let w = NWorkout()
    w.name = name
    w.startDate =
      Date() - Date(timeIntervalSinceNow: -1000).timeIntervalSinceNow
    w.finishDate = Date()
    return w
  }

  func addNewLift(name: String) -> NLift {
    let lift = NLift.new(name: name, workout: self)
    addToLifts(lift)
    return lift
  }
}
