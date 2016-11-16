import CoordinatorKit
import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class MainCoordinator: TabBarCoordinator {
    
   
    override func viewControllerDidLoad() {
        super.viewControllerDidLoad()
        delegate = self
        
        Theme.do()
        
        let wc = WorkoutsCoordinator()
        let wcNav = NavigationCoordinator(rootCoordinator: wc)
        wcNav.tabBarItem.image = #imageLiteral(resourceName: "workout")
        wcNav.tabBarItem.title = "History"
        wc.navigationItem.title = "History"
        
        let rc = RoutinesCoordinator()
        let rcNav = NavigationCoordinator(rootCoordinator: rc)
        rcNav.tabBarItem.image = #imageLiteral(resourceName: "routine")
        rcNav.tabBarItem.title = "Routines"
        rc.navigationItem.title = "Routines"
        
        
        let stc = StatisticsCoordinator()
        let stcNav = NavigationCoordinator(rootCoordinator: stc)
        stcNav.tabBarItem.image = #imageLiteral(resourceName: "statistics")
        stcNav.tabBarItem.title = "Statistics"
        stc.navigationItem.title = "Statistics"
        
        let sec = SettingsCoordinator()
        let secNav = NavigationCoordinator(rootCoordinator: sec)
        secNav.tabBarItem.image = #imageLiteral(resourceName: "settings")
        secNav.tabBarItem.title = "Settings"
        sec.navigationItem.title = "Settings"
        
        let coordinators = [wcNav,rcNav,dummy,stcNav,secNav]
        self.coordinators = coordinators
        
    }
    
    let dummy: Coordinator = {
        let c = Coordinator()
        c.tabBarItem.image = #imageLiteral(resourceName: "newWorkout")
        c.tabBarItem.title = "Start"
        return c
    }()
    
    func makeWorkouts() {
        let workout = Workout()
        workout.append(Lift())
        workout.append(Lift())
        let realm = try! Realm()
        try! realm.write {
            realm.add(workout)
        }
    }
    
    func presentWorkoutCoordinator() {
        if activeWorkoutCoordinator == nil {
            displaySelectWorkout()
        } else {
            displayActiveWorkout()
        }
    }
    
    func displaySelectWorkout() {
        let swc = SelectWorkoutCoordinator()
        let swcNav = NavigationCoordinator(rootCoordinator: swc)
        swc.navigationItem.title = "Select Workout"
        swc.didSelectRoutine = { [unowned self] routine in
            self.activeWorkoutCoordinator = ActiveWorkoutCoordinator()
            if let routine = routine {
                self.activeWorkoutCoordinator!.workout = routine.makeWorkoutWorkout()
            } else {
                self.activeWorkoutCoordinator!.workout = Workout()
            }
            RLM.write {
                RLM.realm.add(self.activeWorkoutCoordinator!.workout)
            }
            self.activeWorkoutCoordinator?.viewController.view.setNeedsLayout()
            self.activeWorkoutCoordinator!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: nil, action: nil)
            self.activeWorkoutCoordinator!.navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true)
            }).addDisposableTo(self.db)
            self.activeWorkoutCoordinator!.workoutIsNotActive = { [unowned self] in
                self.activeWorkoutCoordinator = nil
            }
            return self.activeWorkoutCoordinator!
        }
        
        present(swcNav, animated: true)
    }
    func displayActiveWorkout() {
        let awcNav = NavigationCoordinator(rootCoordinator: activeWorkoutCoordinator!)
        activeWorkoutCoordinator!.navigationItem.title = " Probably should chagne this"
        
        present(awcNav, animated: true)
    }
    
    var activeWorkoutCoordinator: ActiveWorkoutCoordinator?
    
    let db = DisposeBag()
}

extension MainCoordinator: TabBarCoordinatorDelegate {
    func tabBarCoordinator(_ tabBarCoordinator: TabBarCoordinator, shouldSelect coordinator: Coordinator) -> Bool {
        if coordinator === dummy {
            presentWorkoutCoordinator()
            return false
        } else {
            return true
        }
    }
}
































