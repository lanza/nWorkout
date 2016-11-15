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
        wcNav.tabBarItem.title = "Workouts"
        wc.navigationItem.title = "Workouts"
        
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
                self.activeWorkoutCoordinator!.activeWorkout = routine.makeWorkoutWorkout()
            } else {
                self.activeWorkoutCoordinator!.activeWorkout = Workout()
            }
            RLM.write {
                RLM.realm.add(self.activeWorkoutCoordinator!.activeWorkout)
            }
            self.activeWorkoutCoordinator?.viewController.view.setNeedsLayout()
            self.activeWorkoutCoordinator!.navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true)
            }).addDisposableTo(self.db)
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


class WorkoutsCoordinator: Coordinator {
    
    var workoutsTVC: WorkoutsTVC { return viewController as! WorkoutsTVC }
    
    override func loadViewController() {
        viewController = WorkoutsTVC.new()
        
        workoutsTVC.didSelectWorkout = { workout in
            let wvc = WorkoutCoordinator()
            wvc.workout = workout
            self.show(wvc, sender: self)
        }
    }
}

class WorkoutCoordinator: Coordinator {
    var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }
    var workout: Workout!
    
    override func loadViewController() {
        viewController = WorkoutTVC.new()
        workoutTVC.workout = workout
    }
}

class RoutinesCoordinator: Coordinator {
    
    var routinesTVC: RoutinesTVC { return viewController as! RoutinesTVC }
    
    override func loadViewController() {
        viewController = RoutinesTVC.new()
        
        routinesTVC.didSelectRoutine = { routine in
            let rvc = RoutineCoordinator()
            rvc.routine = routine
            self.show(rvc, sender: self)
        }
    }
}

class RoutineCoordinator: Coordinator {
    var routineTVC: RoutineTVC { return viewController as! RoutineTVC }
    var routine: Workout!
    
    override func loadViewController() {
        viewController = RoutineTVC.new()
        routineTVC.routine = routine
    }
}

class ActiveWorkoutCoordinator: Coordinator {
   
    var activeWorkout: Workout!
    var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }
    
    override func loadViewController() {
        viewController = WorkoutTVC.new()
        workoutTVC.workout = activeWorkout
    }
}

class SelectWorkoutCoordinator: Coordinator {
    
    var selectWorkoutVC: SelectWorkoutVC { return viewController as! SelectWorkoutVC }
    
    override func loadViewController() {
        viewController = SelectWorkoutVC.new()
    }
    override func viewControllerDidLoad() {
        super.viewControllerDidLoad()
        
        selectWorkoutVC.navigationItem.leftBarButtonItem!.rx.tap.subscribe(onNext: { [unowned self] in
            self.navigationCoordinator?.parentCoordinator?.dismiss(animated: true)
        }).addDisposableTo(db)
       
        selectWorkoutVC.view.setNeedsLayout()
        
        selectWorkoutVC.tableView.rx.modelSelected(Workout.self).subscribe(onNext: { routine in
            let awc = self.didSelectRoutine(routine)
            self.show(awc, sender: self)
        }).addDisposableTo(db)
        selectWorkoutVC.blankWorkoutButton.rx.tap.subscribe(onNext: {
            let awc = self.didSelectRoutine(Workout())
            self.show(awc, sender: self)
        }).addDisposableTo(db)
        
    }
   
    var didSelectRoutine: ((Workout?) -> (ActiveWorkoutCoordinator))!
    let db = DisposeBag()
}

class StatisticsCoordinator: Coordinator {
    
    var statisticsTVC: StatisticsTVC { return viewController as! StatisticsTVC }
    
    override func loadViewController() {
        viewController = StatisticsTVC.new()
    }
}

class SettingsCoordinator: Coordinator {
    
    var settingsTVC: SettingsTVC { return viewController as! SettingsTVC }
    
    override func loadViewController() {
        viewController = SettingsTVC.new()
    }
}
























