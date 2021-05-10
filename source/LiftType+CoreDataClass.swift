import CoreData
import Foundation

@objc(LiftType)
public class LiftType: NSManagedObject {

  @nonobjc public class func getFetchRequest() -> NSFetchRequest<LiftType> {
    return fetchRequest()
  }

  static func new(name: String) -> LiftType {
    let lt = LiftType(context: coreDataStack.getContext())
    lt.name = name
    return lt
  }

  func getInstancesSorted() -> [NLift] {

    return (instances!.map { $0 } as! [NLift]).sorted(by: {
      $0.workout!.startDate! < $1.workout!.startDate!
    })
  }
}
