import CoordinatorKit
import UIKit

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
