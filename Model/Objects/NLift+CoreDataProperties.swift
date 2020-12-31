import CoreData
import Foundation

extension NLift {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<NLift> {
    return NSFetchRequest<NLift>(entityName: "NLift")
  }

  @NSManaged public var id: UUID?
  @NSManaged public var name: String?
  @NSManaged public var note: String?
  @NSManaged public var previous: NLift?
  @NSManaged public var sets: NSOrderedSet?
  @NSManaged public var workout: NWorkout?

}

// MARK: Generated accessors for sets
extension NLift {

  @objc(insertObject:inSetsAtIndex:)
  @NSManaged public func insertIntoSets(_ value: NSet, at idx: Int)

  @objc(removeObjectFromSetsAtIndex:)
  @NSManaged public func removeFromSets(at idx: Int)

  @objc(insertSets:atIndexes:)
  @NSManaged public func insertIntoSets(
    _ values: [NSet], at indexes: NSIndexSet)

  @objc(removeSetsAtIndexes:)
  @NSManaged public func removeFromSets(at indexes: NSIndexSet)

  @objc(replaceObjectInSetsAtIndex:withObject:)
  @NSManaged public func replaceSets(at idx: Int, with value: NSet)

  @objc(replaceSetsAtIndexes:withSets:)
  @NSManaged public func replaceSets(
    at indexes: NSIndexSet, with values: [NSet])

  @objc(addSetsObject:)
  @NSManaged public func addToSets(_ value: NSet)

  @objc(removeSetsObject:)
  @NSManaged public func removeFromSets(_ value: NSet)

  @objc(addSets:)
  @NSManaged public func addToSets(_ values: NSOrderedSet)

  @objc(removeSets:)
  @NSManaged public func removeFromSets(_ values: NSOrderedSet)

}

extension NLift: Identifiable {

}
