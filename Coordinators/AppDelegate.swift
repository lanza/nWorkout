import CloudKit
import HealthKit
import RealmSwift
import UIKit

func getDocumentsDirectory() -> URL {
  let paths = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
  )
  let documentsDirectory = paths[0]
  return documentsDirectory
}

extension URL {
  var typeIdentifier: String? {
    return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
  }

  var localizedName: String? {
    return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
  }
}

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

    if !UserDefaults.standard.bool(forKey: "hasLeftRealm") {
      guard let workouts = try? Realm().objects(Workout.self) else { fatalError("Fix this") }
      let wos: [Workout] = workouts.map { $0 }

      guard let encoded = try? JSONEncoder().encode(wos) else { fatalError("Fix this") }
      guard let newWorkouts = try? JSONDecoder().decode([NewWorkout].self, from: encoded) else { fatalError("Fix this") }
      
      JDB.setAllWorkouts(with: newWorkouts)
      UserDefaults.standard.set(true, forKey: "hasLeftRealm")
    }

    window = UIWindow()
    window?.rootCoordinator = mainCoordinator
    window?.makeKeyAndVisible()
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    JDB.write()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    JDB.write()
  }
}
