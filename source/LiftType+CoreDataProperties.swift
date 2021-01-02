import CoreData
import Foundation

extension LiftType {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<LiftType> {
    return NSFetchRequest<LiftType>(entityName: "LiftType")
  }

  @NSManaged public var name: String?
  @NSManaged public var instances: NSSet?

}

// MARK: Generated accessors for instances
extension LiftType {

  @objc(addInstancesObject:)
  @NSManaged public func addToInstances(_ value: NLift)

  @objc(removeInstancesObject:)
  @NSManaged public func removeFromInstances(_ value: NLift)

  @objc(addInstances:)
  @NSManaged public func addToInstances(_ values: NSSet)

  @objc(removeInstances:)
  @NSManaged public func removeFromInstances(_ values: NSSet)

}

extension LiftType: Identifiable {

}
