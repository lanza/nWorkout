import UIKit
import CoordinatorKit
import RxSwift
import RxCocoa

class WorkoutCoordinator: Coordinator {
    var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }
    var workout: Workout!
    var isActive: Bool { return !workout.isComplete }
    
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
                    let string = lift.sets.map { "\($0.completedWeight)" + " x " + "\($0.completedReps)" }.joined(separator: ",")
                    UserDefaults.standard.set(string, forKey: "last" + lift.name)
                }
            }
            self.navigationCoordinator?.parent?.dismiss(animated: true)
        }
        workoutTVC.didCancelWorkout = {
            RLM.write {
                self.workout.deleteSelf()
            }
            self.navigationCoordinator?.parent?.dismiss(animated: true)
        }
    }
    
    let db = DisposeBag()
}

extension WorkoutCoordinator: WorkoutTVCDelegate {
    func hideTapped(for workoutTVC: WorkoutTVC) {} // active only
    func showWorkoutDetailTapped(for workoutTVC: WorkoutTVC) {
        let wdc = WorkoutDetailCoordinator(workout: workoutTVC.workout)
        show(wdc, sender: self)
    }
}




