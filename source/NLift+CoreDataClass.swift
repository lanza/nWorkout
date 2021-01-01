import CoreData
import Foundation

@objc(NLift)
public class NLift: NSManagedObject {
  static func new(name: String, workout: NWorkout) -> NLift {
    let lift = NLift(context: coreDataStack.managedObjectContext)
    lift.name = name
    lift.workout = workout
    return lift
  }
  func makeWorkoutLift(workout: NWorkout) -> NLift {
    let lift = NLift.new(name: name!, workout: workout)

    for s in sets! {
      let set = s as! NSet
      let new = set.makeWorkoutSet(lift: self)
      lift.addToSets(new)
    }

    return lift
  }
}

extension NLift: DataProvider {
  func append(_ object: NSet) {
    addToSets(object)
  }
  func numberOfItems() -> Int {
    return sets!.count
  }
  func object(at index: Int) -> NSet {
    return sets!.object(at: index) as! NSet
  }

  func index(of object: NSet) -> Int? {
    return sets!.index(of: object)
  }

  func insert(_ object: NSet, at index: Int) {
    insertIntoSets(object, at: index)
  }

  func remove(at index: Int) {
    removeFromSets(at: index)
  }

  func move(from sourceIndex: Int, to destinationIndex: Int) {
    let set = sets!.object(at: sourceIndex) as! NSet
    removeFromSets(at: sourceIndex)
    insertIntoSets(set, at: destinationIndex)
  }

  static func makeDummy(name: String = "Riley Feeding") -> NLift {
    let l = NLift()
    l.name = name
    l.note = ""
    return l
  }

}
