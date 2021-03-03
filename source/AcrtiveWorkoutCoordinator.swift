import Foundation

protocol ActiveWorkoutCoordinatorDelegate: class {
  func hideTapped(for activeWorkoutCoordinator: ActiveWorkoutCoordinator)
}

class ActiveWorkoutCoordinator: Coordinator {

  override func viewControllerDidLoad() {
    super.viewControllerDidLoad()
  }

  weak var delegate: ActiveWorkoutCoordinatorDelegate!

  var workout: NWorkout!
  var workoutTVC: WorkoutTVC { return viewController as! WorkoutTVC }

  override func loadViewController() {
    viewController = WorkoutTVC()
    workoutTVC.delegate = self
    workoutTVC.workout = workout

    workoutTVC.didTapAddNewLift = {
      let ltc = LiftTypeCoordinator()
      let ltcNav = NavigationCoordinator(rootCoordinator: ltc)

      ltc.liftTypeTVC.hideButtonTappedCallBack = {
        self.dismiss(animated: true)
      }
      ltc.liftTypeTVC.didSelectLiftName = { name in
        self.dismiss(animated: true)
        self.workoutTVC.addNewLift(name: name)
      }

      self.present(ltcNav, animated: true)
    }
  }

  var workoutIsNotActive: (() -> Void)!
}

extension ActiveWorkoutCoordinator: WorkoutTVCDelegate {
  func showWorkoutDetailTapped(for workoutTVC: WorkoutTVC) {
    let wdc = WorkoutDetailCoordinator(workout: workoutTVC.workout)
    show(wdc, sender: self)
  }

  func hideTapped(for workoutTVC: WorkoutTVC) {
    self.delegate.hideTapped(for: self)
  }

  func workoutCancelled(for workoutTVC: WorkoutTVC) {
    DispatchQueue.main.async {
      coreDataStack.getContext().delete(self.workout)
      self.workoutIsNotActive()
    }
    navigationCoordinator?.parent?.dismiss(animated: true)
  }

  func workoutFinished(for workoutTVC: WorkoutTVC) {
    self.workout.isComplete = true
    self.workout.finishDate = Date()
    for l in self.workout.lifts! {
      let lift = l as! NLift
      var strings: [String] = []
      for s in lift.sets! {
        let set = s as! NSet
        let rem = set.completedWeight.remainder(dividingBy: 1)
        var str: String
        if rem == 0 {
          str = String(Int(set.completedWeight))
        } else {
          str = String(set.completedWeight)
        }
        str = str + " x " + String(set.completedReps)
        strings.append(str)
      }
      let joined = strings.joined(separator: ", ")

      // let string = lift.sets.map
      //     { "\(($0.completedWeight.remainder(dividingBy: 1) == 0)
      //       ? String(Int($0.completedWeight)) : String($0.completedWeight))"
      //      + " x " + "\($0.completedReps)" }.joined(separator: ",")
      UserDefaults.standard.set(joined, forKey: "last" + lift.type!.name!)
    }
    workoutIsNotActive()
    navigationCoordinator?.parent?.dismiss(animated: true)

    NotificationCenter.default.post(
      name: Notification.activeWorkoutDidFinish, object: nil)

    // TODO: fix this
    try! coreDataStack.getContext().save()
  }
}

extension Notification {
  static var activeWorkoutDidFinish: Notification.Name {
    return Notification.Name("ActiveWorkoutDidFinish")
  }
}
