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
    window = UIWindow()
    window?.rootCoordinator = mainCoordinator
    window?.makeKeyAndVisible()

    if !UserDefaults.standard.bool(forKey: "HasConvertedFromJSON") {
      let jworkouts = JDB.shared.getWorkouts()
      for jworkout in jworkouts {
        let _ = NWorkout.createfromJWorkout(jworkout)
      }
      try? coreDataStack.managedObjectContext.save()
      UserDefaults.standard.setValue(true, forKey: "HasConvertedFromJSON")
    }

    UITableView.appearance().allowsSelection = false
    UITableViewCell.appearance().selectionStyle = .none

    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    try? coreDataStack.managedObjectContext.save()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    try? coreDataStack.managedObjectContext.save()
    JDB.shared.write()
  }
}
