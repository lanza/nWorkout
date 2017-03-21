import UIKit
import CoordinatorKit
import RealmSwift


class Application {
    static func doOnFirstRun(closure: @escaping ()->()) {
        onFirstRunClosures.append(closure)
    }
    
    private static var onFirstRunClosures: [()->()] = []
  
    private static func callFirstRunClosures() {
        onFirstRunClosures.forEach { $0() }
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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        if let firstRun = UserDefaults.standard.value(forKey: "firstRun") as? Bool, firstRun == false {
            //
        } else {
            UserDefaults.standard.set(true, forKey: Lets.combineFailAndCompletedWeightAndRepsKey)
            UserDefaults.standard.set(false, forKey: "firstRun")
        }
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 2, migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion == 0 {
                fatalError()
            } else if oldSchemaVersion == 1 {
                print("Should be here")
            }
        })
        
        
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
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

