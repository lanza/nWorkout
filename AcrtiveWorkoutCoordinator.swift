import CoordinatorKit
import UIKit
import RxSwift
import RxCocoa

class ActiveWorkoutCoordinator: Coordinator {
    
    var workout: Workout!
    var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }
    
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
        workoutTVC.didFinishWorkout = {
            RLM.write {
                self.workout.isComplete = true
                self.workout.finishDate = Date()
            }
            self.workoutIsNotActive()
            self.navigationCoordinator?.parentCoordinator?.dismiss(animated: true)
        }
        workoutTVC.didCancelWorkout = {
            RLM.write {
                RLM.realm.delete(self.workout)
            }
            self.workoutIsNotActive()
            self.navigationCoordinator?.parentCoordinator?.dismiss(animated: true)
        }
    }
    
    var workoutIsNotActive: (() -> ())!
    let db = DisposeBag()
}
