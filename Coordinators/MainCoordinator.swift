import RealmSwift
import RxCocoa
import RxSwift
import UIKit

class MainCoordinator: TabBarCoordinator {

  func checkForUnfinishedWorkout(displayImmediately: Bool) {
    let workouts = JDB.getWorkouts().filter { $0.isComplete == false }
      .filter { $0.isWorkout == true }

    if let first = workouts.first {
      self.activeWorkoutCoordinator = ActiveWorkoutCoordinator()
      self.activeWorkoutCoordinator?.delegate = self
      self.activeWorkoutCoordinator?.workout = first

      self.activeWorkoutCoordinator?.viewController.view.setNeedsLayout()
      self.activeWorkoutCoordinator!.navigationItem.leftBarButtonItem =
        UIBarButtonItem(
          title: Lets.hide,
          style: .plain,
          target: nil,
          action: nil
        )
      self.activeWorkoutCoordinator!.navigationItem.leftBarButtonItem?.rx.tap
        .subscribe(
          onNext: {
            self.dismiss(animated: true)
          }
        ).disposed(by: self.db)
      self.activeWorkoutCoordinator!.workoutIsNotActive = { [unowned self] in
        self.activeWorkoutCoordinator = nil
      }
      if displayImmediately {
        displayActiveWorkout()
      }
    }
  }

  func createCoordinators() {
    let wc = WorkoutsCoordinator()
    let wcNav = NavigationCoordinator(rootCoordinator: wc)
    wcNav.tabBarItem.image = #imageLiteral(resourceName: "workout")
    wcNav.tabBarItem.title = Lets.history
    wc.navigationItem.title = Lets.history

    let rc = RoutinesCoordinator()
    let rcNav = NavigationCoordinator(rootCoordinator: rc)
    rcNav.tabBarItem.image = #imageLiteral(resourceName: "routine")
    rcNav.tabBarItem.title = Lets.routines
    rc.navigationItem.title = Lets.routines

    let stc = StatisticsCoordinator()
    let stcNav = NavigationCoordinator(rootCoordinator: stc)
    stcNav.tabBarItem.image = #imageLiteral(resourceName: "statistics")
    stcNav.tabBarItem.title = Lets.statistics
    stc.navigationItem.title = Lets.statistics

    let sec = SettingsCoordinator()
    let secNav = NavigationCoordinator(rootCoordinator: sec)
    secNav.tabBarItem.image = #imageLiteral(resourceName: "settings")
    secNav.tabBarItem.title = Lets.settings
    sec.navigationItem.title = Lets.settings

    let coordinators = [wcNav, rcNav, dummy, stcNav, secNav]
    self.coordinators = coordinators

    colorButtons(colorsAndIndices: [(Theme.Colors.main, 2)])
  }

  override func viewControllerDidLoad() {
    super.viewControllerDidLoad()

    delegate = self
    Theme.configure()

    createCoordinators()
    checkForUnfinishedWorkout(displayImmediately: true)

    NotificationCenter.default.rx.notification(
      Notification.Name("settingsDidChange")
    ).subscribe(
      onNext: { notification in
        print("Test")
        self.activeWorkoutCoordinator = nil
        self.checkForUnfinishedWorkout(displayImmediately: false)
      }
    ).disposed(by: db)
  }

  let dummy: Coordinator = {
    let c = Coordinator()
    c.tabBarItem.image = #imageLiteral(resourceName: "newWorkout")
    c.tabBarItem.title = Lets.start
    return c
  }()

  func presentWorkoutCoordinator() {
    if activeWorkoutCoordinator == nil {
      displaySelectWorkout()
    }
    else {
      displayActiveWorkout()
    }
  }

  func displaySelectWorkout() {
    let swc = SelectWorkoutCoordinator()
    swc.delegate = self
    let swcNav = NavigationCoordinator(rootCoordinator: swc)
    swc.navigationItem.title = Lets.selectWorkout
    present(swcNav, animated: true)
  }

  func displayActiveWorkout() {
    let awcNav = NavigationCoordinator(
      rootCoordinator: activeWorkoutCoordinator!
    )

    present(awcNav, animated: true)
  }

  var activeWorkoutCoordinator: ActiveWorkoutCoordinator? {
    didSet {
      if activeWorkoutCoordinator == nil {
        dummy.tabBarItem.image = #imageLiteral(resourceName: "newWorkout")
        dummy.tabBarItem.title = Lets.start
      }
      else {
        dummy.tabBarItem.image = #imageLiteral(resourceName: "show")
        dummy.tabBarItem.title = Lets.show
      }
    }
  }

  let db = DisposeBag()
}

extension MainCoordinator: SelectWorkoutCoordinatorDelegate {
  func selectWorkoutCoordinator(
    _ selectWorkoutCoordinator: SelectWorkoutCoordinator,
    didSelectRoutine routine: NewWorkout?
  ) -> ActiveWorkoutCoordinator {

    activeWorkoutCoordinator = ActiveWorkoutCoordinator()
    activeWorkoutCoordinator?.delegate = self

    if let routine = routine {
      activeWorkoutCoordinator!.workout = routine.makeWorkoutWorkout()
    }
    else {
      activeWorkoutCoordinator!.workout = NewWorkout.new(
        isWorkout: true,
        isComplete: false,
        name: Lets.blank
      )
    }

    activeWorkoutCoordinator!.workoutIsNotActive = { [unowned self] in
      self.activeWorkoutCoordinator = nil
    }
    return activeWorkoutCoordinator!
  }
}

extension MainCoordinator: TabBarCoordinatorDelegate {
  func tabBarCoordinator(
    _ tabBarCoordinator: TabBarCoordinator,
    shouldSelect coordinator: Coordinator
  ) -> Bool {
    if coordinator === dummy {
      presentWorkoutCoordinator()
      return false
    }
    else {
      return true
    }
  }
}

extension MainCoordinator: ActiveWorkoutCoordinatorDelegate {
  func hideTapped(for activeWorkoutCoordinator: ActiveWorkoutCoordinator) {
    dismiss(animated: true)
  }
}
