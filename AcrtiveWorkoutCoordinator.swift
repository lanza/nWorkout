import CoordinatorKit
import UIKit
import RxSwift
import RxCocoa

protocol ActiveWorkoutCoordinatorDelegate: class {
    func hideTapped(for activeWorkoutCoordinator: ActiveWorkoutCoordinator)
}

class ActiveWorkoutCoordinator: Coordinator {
    
    weak var delegate: ActiveWorkoutCoordinatorDelegate!
    
    var workout: Workout!
    var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }
    
    override func loadViewController() {
        viewController = WorkoutTVC()
        workoutTVC.delegate = self
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
                for lift in self.workout.lifts {
                    
                    let string = lift.sets.map { "\(($0.completedWeight.remainder(dividingBy: 1) == 0) ? String(Int($0.completedWeight)) : String($0.completedWeight))" + " x " + "\($0.completedReps)" }.joined(separator: ",")
                    UserDefaults.standard.set(string, forKey: "last" + lift.name)
                }
            }
            self.workoutIsNotActive()
            self.navigationCoordinator?.parent?.dismiss(animated: true)
        }
        workoutTVC.didCancelWorkout = {
            self.workout.deleteSelf()
            self.workoutIsNotActive()
            self.navigationCoordinator?.parent?.dismiss(animated: true)
        }
    }
    
    var workoutIsNotActive: (() -> ())!
    let db = DisposeBag()
}

extension ActiveWorkoutCoordinator: WorkoutTVCDelegate {
    func hideTapped(for workoutTVC: WorkoutTVC) {
        self.delegate.hideTapped(for: self)
    }
}
