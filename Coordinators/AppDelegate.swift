import CloudKit
import HealthKit
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
