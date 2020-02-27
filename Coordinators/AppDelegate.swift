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
        }
        else if oldSchemaVersion == 1 {
          print("Should be here")
        }
      }
    )

    if !UserDefaults.standard.bool(forKey: "hasLeftRealm") {
      let workouts = (try! Realm().objects(Workout.self).map { $0 })
        as [Workout]

      let encoded = try! JSONEncoder().encode(workouts)
      let url = getDocumentsDirectory()
      do {
        try encoded.write(to: url.appendingPathComponent("data.json"))
      }
      catch {
        fatalError()
      }
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
