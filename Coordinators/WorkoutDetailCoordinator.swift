import UIKit

class WorkoutDetailCoordinator: Coordinator {

  let workout: NewWorkout!

  var workoutDetailVC: WorkoutDetailVC {
    return viewController as! WorkoutDetailVC
  }

  init(workout: NewWorkout) {
    self.workout = workout
    super.init()
  }

  override func loadViewController() {
    viewController = WorkoutDetailVC(workout: workout)
  }

}
