import CoreData
import Foundation

@objc(LiftType)
public class LiftType: NSManagedObject {

  @nonobjc public class func getFetchRequest() -> NSFetchRequest<LiftType> {
    return fetchRequest()
  }

  static func new(name: String) -> LiftType {
    let lt = LiftType(context: coreDataStack.managedObjectContext)
    lt.name = name
    return lt
  }

  func sortInstances() {
    let i = instances! as! NSMutableOrderedSet
    i.sort(using: [NSSortDescriptor(key: "workout.startDate", ascending: true)])
  }
}
