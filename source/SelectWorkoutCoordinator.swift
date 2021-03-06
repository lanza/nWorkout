import UIKit

protocol SelectWorkoutCoordinatorDelegate: AnyObject {
  func selectWorkoutCoordinator(
    _ selectWorkoutCoordinator: SelectWorkoutCoordinator,
    didSelectRoutine routine: NWorkout?
  ) -> ActiveWorkoutCoordinator
}

class SelectWorkoutCoordinator: Coordinator {

  weak var delegate: SelectWorkoutCoordinatorDelegate!

  var selectWorkoutVC: SelectWorkoutVC {
    return viewController as! SelectWorkoutVC
  }

  override func loadViewController() {
    viewController = SelectWorkoutVC()
    selectWorkoutVC.delegate = self
  }
}

extension SelectWorkoutCoordinator: SelectWorkoutDelegate {
  func cancelSelected(for selectWorkoutVC: SelectWorkoutVC) {
    navigationCoordinator?.parent?.dismiss(animated: true)
  }

  func startBlankWorkoutSelected(for selectWorkoutVC: SelectWorkoutVC) {
    let awc = delegate.selectWorkoutCoordinator(self, didSelectRoutine: nil)
    self.show(awc, sender: self)
  }

  func selectWorkoutVC(
    _ selectWorkoutVC: SelectWorkoutVC,
    selectedRoutine routine: NWorkout
  ) {
    let awc = delegate.selectWorkoutCoordinator(self, didSelectRoutine: routine)
    self.show(awc, sender: self)
  }
}
