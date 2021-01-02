import CoreData
import Foundation

@objc(NLift)
public class NLift: NSManagedObject {

  @nonobjc public class func getFetchRequest() -> NSFetchRequest<NLift> {
    return NSFetchRequest<NLift>(entityName: "NLift")
  }

  func getName() -> String {
    return type!.name!
  }
  func setName(_ name: String) {
    type!.name = name
  }

  static func new(name: String, workout: NWorkout) -> NLift {
    let lift = NLift(context: coreDataStack.managedObjectContext)
    // TODO: Clean up this garbage usage
    let types = try! coreDataStack.managedObjectContext.fetch(
      LiftType.getFetchRequest())
    lift.type =
      types.first(where: { $0.name == name }) ?? LiftType.new(name: name)
    lift.setName(name)
    lift.workout = workout
    return lift
  }

  func makeWorkoutLift(workout: NWorkout) -> NLift {
    let lift = NLift.new(name: getName(), workout: workout)

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
    let lt = LiftType()
    lt.name = name
    l.type = lt
    l.note = ""
    return l
  }

}
