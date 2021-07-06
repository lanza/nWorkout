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
    // TODO: I have to filter out lifts with nil workouts. This means something
    // was erroneoulsy deleting workouts but not the corresponding lifts (and
    // surely sets as well.
    return (instances!.map { $0 } as! [NLift]).filter { $0.workout != nil }
      .sorted(by: {
        $0.workout!.startDate! < $1.workout!.startDate!
      })
  }
}
