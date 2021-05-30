import SwiftUI
import UIKit

class RoutinesCoordinator: Coordinator {

  var routinesTVC: RoutinesTVC { return viewController as! RoutinesTVC }

  override func loadViewController() {
    let workouts = try! coreDataStack.getContext().fetch(
      NWorkout.getFetchRequest())
    let hostingVC = UIHostingController(
      rootView: WorkoutsView(workouts: workouts))
    hostingVC.view.backgroundColor = Theme.Colors.darkest
    viewController = hostingVC
  }
}

extension RoutinesCoordinator: WorkoutsTVCDelegate {
  func routinesTVC(
    _ routinesTVC: RoutinesTVC,
    didSelectRoutine routine: NWorkout
  ) {
    let rvc = RoutineCoordinator()
    rvc.routine = routine
    self.show(rvc, sender: self)
  }

  func workoutsTVC(
    _ workoutsTVC: WorkoutsTVC,
    didSelectWorkout workout: NWorkout
  ) {
    fatalError()
  }
}
