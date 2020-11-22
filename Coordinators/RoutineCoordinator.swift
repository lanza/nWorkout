import UIKit

class RoutineCoordinator: Coordinator {
  var routineTVC: RoutineTVC { return viewController as! RoutineTVC }
  var routine: NWorkout!

  override func loadViewController() {
    viewController = RoutineTVC()
    routineTVC.workout = routine

    routineTVC.didTapAddNewLift = {
      let ltc = LiftTypeCoordinator()
      let ltcNav = NavigationCoordinator(rootCoordinator: ltc)
      ltc.liftTypeTVC.hideButtonTappedCallBack = {
        self.dismiss(animated: true)
      }

      ltc.liftTypeTVC.didSelectLiftName = { name in
        self.dismiss(animated: true)
        self.routineTVC.addNewLift(name: name)
      }

      self.present(ltcNav, animated: true)
    }
  }
}
