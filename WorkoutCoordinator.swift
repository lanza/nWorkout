import UIKit
import CoordinatorKit

class WorkoutCoordinator: Coordinator {
    var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }
    var workout: Workout!
    
    override func loadViewController() {
        viewController = WorkoutTVC.new()
        workoutTVC.workout = workout
    }
}
