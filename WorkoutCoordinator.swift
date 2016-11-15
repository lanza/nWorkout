import UIKit
import CoordinatorKit

class WorkoutCoordinator: Coordinator {
    var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }
    var workout: Workout!
    
    override func loadViewController() {
        viewController = WorkoutTVC.new()
        workoutTVC.workout = workout
        
        workoutTVC.didTapAddNewLift = {
            let ltc = LiftTypeCoordinator()
            let ltcNav = NavigationCoordinator(rootCoordinator: ltc)
            self.show(ltcNav, sender: self)
        }
    }
}


class LiftTypeCoordinator: Coordinator {
    var liftTypeTVC: LiftTypeTVC { return viewController as! LiftTypeTVC }
    
    override func loadViewController() {
        viewController = LiftTypeTVC.new()
    }
}
