import RxCocoa
import RxSwift
import UIKit

class RoutineCoordinator: Coordinator {
  var routineTVC: RoutineTVC { return viewController as! RoutineTVC }
  var routine: NewWorkout!

  override func loadViewController() {
    viewController = RoutineTVC()
    routineTVC.workout = routine

    routineTVC.didTapAddNewLift = {
      let ltc = LiftTypeCoordinator()
      let ltcNav = NavigationCoordinator(rootCoordinator: ltc)

      ltc.liftTypeTVC.navigationItem.leftBarButtonItem!.rx.tap.subscribe(
        onNext: {
          self.dismiss(animated: true)
        }
      ).disposed(by: self.db)

      ltc.liftTypeTVC.didSelectLiftName = { name in
        self.dismiss(animated: true)
        self.routineTVC.addNewLift(name: name)
      }

      self.present(ltcNav, animated: true)
    }
  }

  let db = DisposeBag()
}
