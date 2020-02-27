import UIKit

class WorkoutsCoordinator: Coordinator {

  var workoutsTVC: WorkoutsTVC { return viewController as! WorkoutsTVC }

  override func loadViewController() {
    viewController = WorkoutsTVC()
    workoutsTVC.delegate = self
  }
}

extension WorkoutsCoordinator: WorkoutsTVCDelegate {
  func routinesTVC(
    _ routinesTVC: RoutinesTVC,
    didSelectRoutine routine: Workout
  ) {
    fatalError()  //fuck swift
  }

  func workoutsTVC(
    _ workoutsTVC: WorkoutsTVC,
    didSelectWorkout workout: Workout
  ) {
    let wvc = WorkoutCoordinator()
    wvc.workout = workout
    show(wvc, sender: self)
  }
}
