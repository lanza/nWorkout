import CoordinatorKit
import UIKit
import RealmSwift

class MainCoordinator: TabBarCoordinator {
    
   
    override func viewControllerDidLoad() {
        super.viewControllerDidLoad()
        
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
        
        let nwc = NewWorkoutCoordinator()
        let nwcNav = NavigationCoordinator(rootCoordinator: nwc)
        nwcNav.tabBarItem.image = #imageLiteral(resourceName: "newWorkout")
        nwcNav.tabBarItem.title = "Start"
        
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
        
        let coordinators = [wcNav,rcNav,nwcNav,stcNav,secNav]
        self.coordinators = coordinators
        
    }
    
    func makeWorkouts() {
        let workout = Workout()
        workout.append(Lift())
        workout.append(Lift())
        let realm = try! Realm()
        try! realm.write {
            realm.add(workout)
        }
    }
}


class WorkoutsCoordinator: Coordinator {
    
    var workoutsTVC: WorkoutsTVC { return viewController as! WorkoutsTVC }
    
    override func loadViewController() {
        viewController = WorkoutsTVC.new()
    }
}

class RoutinesCoordinator: Coordinator {
    
    var routinesTVC: RoutinesTVC { return viewController as! RoutinesTVC }
    
    override func loadViewController() {
        viewController = RoutinesTVC.new()
    }
}

class NewWorkoutCoordinator: Coordinator {
    
    var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }
    
    override func loadViewController() {
        viewController = WorkoutTVC.new()
    }
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
























