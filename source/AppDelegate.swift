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

      let nworkouts = try! coreDataStack.getContext().fetch(
        NWorkout.getFetchRequest()
      ).sorted(by: { lhs, rhs in
        return lhs.startDate! < rhs.startDate!
      })

      for i in nworkouts.indices.dropLast() {
        if nworkouts[i].isDuplicate(of: nworkouts[i + 1]) {
          coreDataStack.getContext().delete(nworkouts[i])
        }
      }

      try? coreDataStack.saveContext()
      UserDefaults.standard.setValue(true, forKey: "HasConvertedFromJSON")
    }

    UITableView.appearance().allowsSelection = false
    UITableViewCell.appearance().selectionStyle = .none

    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    do {
      try coreDataStack.saveContext()
    } catch _ {
      crash(
        in: mainCoordinator.viewController,
        with: "Failed to save coreDataContext in \(#function)")
    }
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    do {
      try coreDataStack.saveContext()
    } catch _ {
      crash(
        in: mainCoordinator.viewController,
        with: "Failed to save coreDataContext in \(#function)")
    }
  }

  func applicationWillResignActive(_ application: UIApplication) {
    do {
      try coreDataStack.saveContext()
    } catch _ {
      crash(
        in: mainCoordinator.viewController,
        with: "Failed to save coreDataContext in \(#function)")
    }
  }
}
