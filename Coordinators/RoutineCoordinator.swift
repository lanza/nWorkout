import UIKit
import CoordinatorKit
import RxSwift
import RxCocoa

class RoutineCoordinator: Coordinator {
    var routineTVC: RoutineTVC { return viewController as! RoutineTVC }
    var routine: Workout!
    
    override func loadViewController() {
        viewController = RoutineTVC()
        routineTVC.workout = routine

        routineTVC.didTapAddNewLift = {
            let ltc = LiftTypeCoordinator()
            let ltcNav = NavigationCoordinator(rootCoordinator: ltc)
            
            ltc.liftTypeTVC.navigationItem.leftBarButtonItem!.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true)
            }).addDisposableTo(self.db)
            
            ltc.liftTypeTVC.didSelectLiftName = { name in
                self.dismiss(animated: true)
                self.routineTVC.addNewLift(name: name)
            }
            
            self.present(ltcNav, animated: true)
        }
    }
    let db = DisposeBag()
}
