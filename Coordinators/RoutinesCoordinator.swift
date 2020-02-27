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
    didSelectRoutine routine: NewWorkout
  ) {
    let rvc = RoutineCoordinator()
    rvc.routine = routine
    self.show(rvc, sender: self)
  }

  func workoutsTVC(
    _ workoutsTVC: WorkoutsTVC,
    didSelectWorkout workout: NewWorkout
  ) {
    fatalError()
  }
}
