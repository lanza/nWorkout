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

    UITableView.appearance().allowsSelection = false
    UITableViewCell.appearance().selectionStyle = .none

    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    JDB.shared.write()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    JDB.shared.write()
  }
}
