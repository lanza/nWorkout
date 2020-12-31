import CoreData
import Foundation

extension NWorkout {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<NWorkout> {
    return NSFetchRequest<NWorkout>(entityName: "NWorkout")
  }

  @NSManaged public var finishDate: Date?
  @NSManaged public var id: UUID?
  @NSManaged public var isComplete: Bool
  @NSManaged public var name: String?
  @NSManaged public var note: String?
  @NSManaged public var startDate: Date?
  @NSManaged public var lifts: NSOrderedSet?

}

// MARK: Generated accessors for lifts
extension NWorkout {

  @objc(insertObject:inLiftsAtIndex:)
  @NSManaged public func insertIntoLifts(_ value: NLift, at idx: Int)

  @objc(removeObjectFromLiftsAtIndex:)
  @NSManaged public func removeFromLifts(at idx: Int)

  @objc(insertLifts:atIndexes:)
  @NSManaged public func insertIntoLifts(
    _ values: [NLift], at indexes: NSIndexSet)

  @objc(removeLiftsAtIndexes:)
  @NSManaged public func removeFromLifts(at indexes: NSIndexSet)

  @objc(replaceObjectInLiftsAtIndex:withObject:)
  @NSManaged public func replaceLifts(at idx: Int, with value: NLift)

  @objc(replaceLiftsAtIndexes:withLifts:)
  @NSManaged public func replaceLifts(
    at indexes: NSIndexSet, with values: [NLift])

  @objc(addLiftsObject:)
  @NSManaged public func addToLifts(_ value: NLift)

  @objc(removeLiftsObject:)
  @NSManaged public func removeFromLifts(_ value: NLift)

  @objc(addLifts:)
  @NSManaged public func addToLifts(_ values: NSOrderedSet)

  @objc(removeLifts:)
  @NSManaged public func removeFromLifts(_ values: NSOrderedSet)

}

extension NWorkout: Identifiable {

}
