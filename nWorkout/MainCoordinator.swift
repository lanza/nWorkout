import CoordinatorKit
import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class MainCoordinator: TabBarCoordinator {
  
    func checkForUnfinishedWorkout() {
        let workouts = RLM.realm.objects(Workout.self).filter("isComplete = false").filter("isWorkout = true")
        if let first = workouts.first {
            self.activeWorkoutCoordinator = ActiveWorkoutCoordinator()
            self.activeWorkoutCoordinator?.delegate = self
            self.activeWorkoutCoordinator?.workout = first
            
            self.activeWorkoutCoordinator?.viewController.view.setNeedsLayout()
            self.activeWorkoutCoordinator!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Lets.hide, style: .plain, target: nil, action: nil)
            self.activeWorkoutCoordinator!.navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true)
            }).addDisposableTo(self.db)
            self.activeWorkoutCoordinator!.workoutIsNotActive = { [unowned self] in
                self.activeWorkoutCoordinator = nil
            }
            displayActiveWorkout()
        }
    }
    
    func createCoordinators() {
        let wc = WorkoutsCoordinator()
        let wcNav = NavigationCoordinator(rootCoordinator: wc)
        wcNav.tabBarItem.image = #imageLiteral(resourceName: "workout")
        wcNav.tabBarItem.title = Lets.history
        wc.navigationItem.title = Lets.history
        
        let rc = RoutinesCoordinator()
        let rcNav = NavigationCoordinator(rootCoordinator: rc)
        rcNav.tabBarItem.image = #imageLiteral(resourceName: "routine")
        rcNav.tabBarItem.title = Lets.routines
        rc.navigationItem.title = Lets.routines
        
        let stc = StatisticsCoordinator()
        let stcNav = NavigationCoordinator(rootCoordinator: stc)
        stcNav.tabBarItem.image = #imageLiteral(resourceName: "statistics")
        stcNav.tabBarItem.title = Lets.statistics
        stc.navigationItem.title = Lets.statistics
        
        let sec = SettingsCoordinator()
        let secNav = NavigationCoordinator(rootCoordinator: sec)
        secNav.tabBarItem.image = #imageLiteral(resourceName: "settings")
        secNav.tabBarItem.title = Lets.settings
        sec.navigationItem.title = Lets.settings
        
        let coordinators = [wcNav,rcNav,dummy,stcNav,secNav]
        self.coordinators = coordinators
        
        colorButtons(colorsAndIndices: [(Theme.Colors.main,2)])
    }
    
   
    override func viewControllerDidLoad() {
        super.viewControllerDidLoad()
        
        delegate = self
        Theme.do()
    
        createCoordinators()
        checkForUnfinishedWorkout()
    }
    
    let dummy: Coordinator = {
        let c = Coordinator()
        c.tabBarItem.image = #imageLiteral(resourceName: "newWorkout")
        c.tabBarItem.title = Lets.start
        return c
    }()
    
    func presentWorkoutCoordinator() {
        if activeWorkoutCoordinator == nil {
            displaySelectWorkout()
        } else {
            displayActiveWorkout()
        }
    }
    
    func displaySelectWorkout() {
        let swc = SelectWorkoutCoordinator()
        swc.delegate = self
        let swcNav = NavigationCoordinator(rootCoordinator: swc)
        swc.navigationItem.title = Lets.selectWorkout
        present(swcNav, animated: true)
    }
    func displayActiveWorkout() {
        let awcNav = NavigationCoordinator(rootCoordinator: activeWorkoutCoordinator!)
        
        present(awcNav, animated: true)
    }
    
    var activeWorkoutCoordinator: ActiveWorkoutCoordinator? {
        didSet {
            if activeWorkoutCoordinator == nil {
                dummy.tabBarItem.image = #imageLiteral(resourceName: "newWorkout")
                dummy.tabBarItem.title = Lets.start
            } else {
                dummy.tabBarItem.image = #imageLiteral(resourceName: "show")
                dummy.tabBarItem.title = Lets.show
            }
        }
    }
    
    let db = DisposeBag()
}

extension MainCoordinator: SelectWorkoutCoordinatorDelegate {
    func selectWorkoutCoordinator(_ selectWorkoutCoordinator: SelectWorkoutCoordinator, didSelectRoutine routine: Workout?) -> ActiveWorkoutCoordinator {
        
        activeWorkoutCoordinator = ActiveWorkoutCoordinator()
        activeWorkoutCoordinator?.delegate = self
        
        if let routine = routine {
            activeWorkoutCoordinator!.workout = routine.makeWorkoutWorkout()
        } else {
            activeWorkoutCoordinator!.workout = Workout.new(isWorkout: true, isComplete: false, name: Lets.blank)
        }
        RLM.write {
            RLM.realm.add(self.activeWorkoutCoordinator!.workout)
        }

        activeWorkoutCoordinator!.workoutIsNotActive = { [unowned self] in
            self.activeWorkoutCoordinator = nil
        }
        return  activeWorkoutCoordinator!
    }
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

extension MainCoordinator: ActiveWorkoutCoordinatorDelegate {
    func hideTapped(for activeWorkoutCoordinator: ActiveWorkoutCoordinator) {
        dismiss(animated: true)
    }
}
































