import CoordinatorKit
import UIKit
import RealmSwift

class MainCoordinator: TabBarCoordinator {
    
   
    override func viewControllerDidLoad() {
        super.viewControllerDidLoad()
        
        Theme.do()
        
        let wsc = WorkoutsCoordinator()
        let workoutsNav = NavigationCoordinator(rootCoordinator: wsc)
        workoutsNav.tabBarItem.image = #imageLiteral(resourceName: "workout")
        workoutsNav.tabBarItem.title = "Workouts"
        wsc.navigationItem.title = "Workouts"
        
        let coordinators = [workoutsNav]
        self.coordinators = coordinators
        
        for i in 1...4 {
            makeWorkouts()
            
        }
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


