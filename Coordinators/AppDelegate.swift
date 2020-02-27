import CloudKit
import HealthKit
import RealmSwift
import UIKit

//class Application {
//    static func doOnFirstRun(closure: @escaping ()->()) {
//        onFirstRunClosures.append(closure)
//    }
//    
//    private static var onFirstRunClosures: [()->()] = []
//  
//    private static func callFirstRunClosures() {
//        onFirstRunClosures.forEach { $0() }
//    }
//}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  override init() {
    super.init()

    AppDelegate.main = self
  }

  static var main: AppDelegate!
  var window: UIWindow?

  let mainCoordinator = MainCoordinator()

  func requestAccessToHealthKit() {
    //        let healthStore = HKHealthStore()
    //
    //        let types = Swift.Set([HKObjectType.workoutType(), HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!])
    //        healthStore.requestAuthorization(toShare: types, read: types) { (success, error) in
    //            if !success {
    //                print(error!)
    //            }
    //        }
  }

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
      [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    requestAccessToHealthKit()

    if let firstRun = UserDefaults.standard.value(forKey: "firstRun") as? Bool,
      firstRun == false
    {
      //
    } else {
      UserDefaults.standard.set(
        true,
        forKey: Lets.combineFailAndCompletedWeightAndRepsKey
      )
      UserDefaults.standard.set(false, forKey: "firstRun")
    }

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

    // Not sure why I ever this chunk of code. Don't know when
    // I would have wanted to delete everything
    //        let lifts = try! Realm().objects(Lift.self)
    //        for lift in lifts {
    //            if lift.workout == nil {
    //                lift.deleteSelf()
    //            }
    //        }
    //        let sets = try! Realm().objects(Set.self)
    //        for set in sets {
    //            if set.lift == nil {
    //                set.deleteSelf()
    //            }
    //        }

    window = UIWindow()

    window?.rootCoordinator = mainCoordinator
    window?.makeKeyAndVisible()
    return true
  }
}
