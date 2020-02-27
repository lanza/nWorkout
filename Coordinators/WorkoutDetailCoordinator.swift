import UIKit

class WorkoutDetailCoordinator: Coordinator {

  let workout: Workout!

  var workoutDetailVC: WorkoutDetailVC {
    return viewController as! WorkoutDetailVC
  }

  init(workout: Workout) {
    self.workout = workout
    super.init()
  }

  override func loadViewController() {
    viewController = WorkoutDetailVC(workout: workout)
  }

}
