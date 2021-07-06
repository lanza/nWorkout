import Foundation
import UIKit

func crash(in vc: UIViewController, with message: String? = nil) -> Never {
  let alert = UIAlertController(
    title: message ?? "Crashed unwrapping in \(#function)",
    message: Thread.callStackSymbols.joined(separator: "\n"),
    preferredStyle: .alert)
  alert.addAction(
    UIAlertAction(
      title: "Okay", style: .destructive,
      handler: { action in
        fatalError("Crashed unwrapping in \(#function)")
      }))
  vc.present(alert, animated: true, completion: nil)
  fatalError("Crashed unwrapping in \(#function)")
}

protocol ActiveWorkoutCoordinatorDelegate: AnyObject {
  func hideTapped(for activeWorkoutCoordinator: ActiveWorkoutCoordinator)
}

class ActiveWorkoutCoordinator: Coordinator {

  override func viewControllerDidLoad() {
    super.viewControllerDidLoad()
  }

  weak var delegate: ActiveWorkoutCoordinatorDelegate?

  var workout: NWorkout?
  var workoutTVC: WorkoutTVC {
    guard let vc = viewController as? WorkoutTVC else {
      guard let parent = parent else { fatalError("lol?") }
      crash(
        in: parent.viewController,
        with:
          "Crashed unwrapping workoutTVC in ActiveWorkoutCoordinator.workoutTVC"
      )
    }
    return vc
  }

  override func loadViewController() {
    viewController = WorkoutTVC()
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

  var workoutIsNotActive: (() -> Void)?
}

extension ActiveWorkoutCoordinator {  // : WorkoutTVCDelegate {
  func hideTapped(for workoutTVC: WorkoutTVC) {
    self.delegate?.hideTapped(for: self)
  }

  func workoutCancelled(for workoutTVC: WorkoutTVC) {
    DispatchQueue.main.async {
      guard let w = self.workout else {
        crash(in: self.viewController)
      }
      coreDataStack.getContext().delete(w)
      guard let workoutIsNotActive = self.workoutIsNotActive else {
        crash(in: self.viewController)
      }
      workoutIsNotActive()
    }
    navigationCoordinator?.parent?.dismiss(animated: true)
  }

  func workoutFinished(for workoutTVC: WorkoutTVC) {
    guard let w = self.workout else {
      crash(
        in: viewController,
        with: "There was no workout in ActiveWorkoutCoordinator.workoutFinished"
      )
    }
    w.isComplete = true
    w.finishDate = Date()
    for l in w.lifts! {
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
    guard let wina = self.workoutIsNotActive else {
      crash(
        in: viewController,
        with: "ActiveWorkoutCoordinator.workokutIsNotActive was nil")
    }
    wina()
    navigationCoordinator?.parent?.dismiss(animated: true)

    NotificationCenter.default.post(
      name: Notification.activeWorkoutDidFinish, object: nil)

    do {
      try coreDataStack.saveContext()
    } catch let e {
      print(e)
      crash(in: viewController, with: "Couldn't save")
    }
  }
}

extension Notification {
  static var activeWorkoutDidFinish: Notification.Name {
    return Notification.Name("ActiveWorkoutDidFinish")
  }
}
