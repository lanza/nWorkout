import CoreData
import Foundation

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

  func sortInstances() {
    let i = instances! as! NSMutableOrderedSet
    i.sort { left, right in
      let l = left as! NLift
      let r = right as! NLift
      return (l.workout!.startDate! > r.workout!.startDate!)
        ? .orderedAscending : .orderedDescending
    }
  }
}
