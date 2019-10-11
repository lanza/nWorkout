import CoordinatorKit
import UIKit

class RoutinesCoordinator: Coordinator {

  var routinesTVC: RoutinesTVC { return viewController as! RoutinesTVC }

  override func loadViewController() {
    viewController = RoutinesTVC()
    routinesTVC.delegate = self
  }
}

extension RoutinesCoordinator: WorkoutsTVCDelegate {
  func routinesTVC(
    _ routinesTVC: RoutinesTVC,
    didSelectRoutine routine: Workout
  ) {
    let rvc = RoutineCoordinator()
    rvc.routine = routine
    self.show(rvc, sender: self)
  }

  func workoutsTVC(
    _ workoutsTVC: WorkoutsTVC,
    didSelectWorkout workout: Workout
  ) {
    fatalError()
    //fuck swift
  }
}
