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
    didSelectRoutine routine: NewWorkout
  ) {
    fatalError()  //fuck swift
  }

  func workoutsTVC(
    _ workoutsTVC: WorkoutsTVC,
    didSelectWorkout workout: NewWorkout
  ) {
    let wvc = WorkoutCoordinator()
    wvc.workout = workout
    show(wvc, sender: self)
  }
}
