import Foundation
import CoreData

@objc(LiftType)
public class LiftType: NSManagedObject {
  @nonobjc public class func getFetchRequest() -> NSFetchRequest<LiftType> {
      return NSFetchRequest<LiftType>(entityName: "LiftType")
  }
  
  static func new(name: String) -> LiftType {
    let lt = LiftType(context: coreDataStack.managedObjectContext)
    lt.name = name
    return lt
  }
}
