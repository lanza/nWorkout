import CoordinatorKit
import UIKit

class MainCoordinator: TabBarCoordinator {
    
    override func start() {
        super.start()
        setupTBC()
    }
    
    func setupTBC() {
        let wsc = WorkoutsCoordinator()
        wsc.start()
        let workoutsNav = NavigationCoordinator(rootCoordinator: wsc)
        workoutsNav.tabBarItem.image = #imageLiteral(resourceName: "workout")
//        workoutsNav.tabBarItem.title = "Workouts"
        wsc.navigationItem.title = "Workouts"
        
        let coordinators = [workoutsNav]
        self.coordinators = coordinators
    }
}


class WorkoutsCoordinator: Coordinator {
    
    var workoutsTVC: WorkoutsTVC { return viewController as! WorkoutsTVC }
    
    override func start() {
        super.start()
        viewController = WorkoutsTVC()
    }
}

