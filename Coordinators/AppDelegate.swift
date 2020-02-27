import CloudKit
import HealthKit
import RealmSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  override init() {
    super.init()

    AppDelegate.main = self
  }

  static var main: AppDelegate!
  var window: UIWindow?

  let mainCoordinator = MainCoordinator()

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
      [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    Realm.Configuration.defaultConfiguration = Realm.Configuration(
      schemaVersion: 2,
      migrationBlock: { migration, oldSchemaVersion in
        if oldSchemaVersion == 0 {
          fatalError()
        } else if oldSchemaVersion == 1 {
          print("Should be here")
        }
      }
    )

    let workouts = try! Realm().objects(Workout.self)

    for workout in workouts {
      let encoded = try! JSONEncoder().encode(workout)
      print(String(data: encoded, encoding: .utf8)!)
    } 

//    let lifts = try! Realm().objects(Lift.self)
//    for lift in lifts {
//      if lift.workout == nil {
//        lift.deleteSelf()
//      }
//    }
//    let sets = try! Realm().objects(Set.self)
//    for set in sets {
//      if set.lift == nil {
//        set.deleteSelf()
//      }
//    }

    window = UIWindow()

    window?.rootCoordinator = mainCoordinator
    window?.makeKeyAndVisible()
    return true
  }
}
