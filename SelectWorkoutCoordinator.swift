import UIKit
import CoordinatorKit

class ActiveWorkoutCoordinator: Coordinator {
    
    var activeWorkout: Workout!
    var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }
    
    override func loadViewController() {
        viewController = WorkoutTVC.new()
        workoutTVC.workout = activeWorkout
    }
}
