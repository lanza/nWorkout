import UIKit
import CoordinatorKit
import RxSwift
import RxCocoa

class WorkoutCoordinator: Coordinator {
    var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }
    var workout: Workout!
    
    override func loadViewController() {
        viewController = WorkoutTVC.new()
        workoutTVC.workout = workout
        
        workoutTVC.didTapAddNewLift = {
            let ltc = LiftTypeCoordinator()
            let ltcNav = NavigationCoordinator(rootCoordinator: ltc)
           
            ltc.liftTypeTVC.navigationItem.leftBarButtonItem!.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true)
            }).addDisposableTo(self.db)
            
            ltc.liftTypeTVC.didSelectLiftName = { name in
                self.dismiss(animated: true)
                self.workoutTVC.addNewLift(name: name)
            }
            
            self.present(ltcNav, animated: true)
        }
    }
    let db = DisposeBag()
}


class LiftTypeCoordinator: Coordinator {
    var liftTypeTVC: LiftTypeTVC { return viewController as! LiftTypeTVC }
    
    override func loadViewController() {
        viewController = LiftTypeTVC.new()
    }
    let db = DisposeBag()
}
