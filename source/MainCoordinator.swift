import UIKit

class MainCoordinator: TabBarCoordinator {

  @objc func hideButtonTapped() {
    self.dismiss(animated: true)
  }

  func checkForUnfinishedWorkout(displayImmediately: Bool) {
    let request = NWorkout.getFetchRequest()
    request.fetchLimit = 1
    request.predicate = NSPredicate(format: "isComplete = false")
    guard
      let fetchedWorkouts = try? coreDataStack.getContext().fetch(
        request)
    else { return }

    guard let first = fetchedWorkouts.first else { return }
    self.activeWorkoutCoordinator = ActiveWorkoutCoordinator()
    self.activeWorkoutCoordinator?.delegate = self
    self.activeWorkoutCoordinator?.workout = first

    self.activeWorkoutCoordinator?.viewController.view.setNeedsLayout()
    self.activeWorkoutCoordinator!.navigationItem.leftBarButtonItem =
      UIBarButtonItem(
        title: Lets.hide,
        style: .plain,
        target: self,
        action: #selector(hideButtonTapped)
      )
    self.activeWorkoutCoordinator!.workoutIsNotActive = { [unowned self] in
      self.activeWorkoutCoordinator = nil
    }
    if displayImmediately {
      displayActiveWorkout()
    }
  }

  func createCoordinators() {

    let wc = WorkoutsCoordinator()
    let wcNav = NavigationCoordinator(rootCoordinator: wc)
    wcNav.tabBarItem.image = #imageLiteral(resourceName: "workout")
    wcNav.tabBarItem.title = Lets.history
    wc.navigationItem.title = Lets.history

    let rc = RoutinesCoordinator()
    rc.tabBarItem.image = #imageLiteral(resourceName: "routine")
    rc.tabBarItem.title = Lets.routines
    rc.navigationItem.title = Lets.routines

    let stc = StatisticsCoordinator()
    stc.tabBarItem.image = #imageLiteral(resourceName: "statistics")
    stc.tabBarItem.title = Lets.statistics
    stc.navigationItem.title = Lets.statistics

    let sec = SettingsCoordinator()
    let secNav = NavigationCoordinator(rootCoordinator: sec)
    secNav.tabBarItem.image = #imageLiteral(resourceName: "settings")
    secNav.tabBarItem.title = Lets.settings

    sec.navigationItem.title = Lets.settings

    let coordinators = [wcNav, rc, dummy, stc, secNav]
    self.coordinators = coordinators
  }

  @objc func settingsDidChange() {
    self.activeWorkoutCoordinator = nil
    self.checkForUnfinishedWorkout(displayImmediately: false)
  }

  override func viewControllerDidLoad() {
    super.viewControllerDidLoad()

    delegate = self

    createCoordinators()
    checkForUnfinishedWorkout(displayImmediately: true)

    NotificationCenter.default.addObserver(
      self, selector: #selector(settingsDidChange),
      name: Notification.Name("settingsDidChange"), object: nil)
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
    } else {
      displayActiveWorkout()
    }
  }

  func displaySelectWorkout() {
    // TODO: teach this about routines again
    //    if JDB.shared.getWorkouts().filter({ $0.isWorkout == false }).count == 0 {
    //      let active = makeActiveWorkoutCoordinator(for: nil)
    //      let aNav = NavigationCoordinator(rootCoordinator: active)
    //      active.navigationItem.title = Lets.selectWorkout
    //      present(aNav, animated: true)
    //    } else {
    let swc = SelectWorkoutCoordinator()
    swc.delegate = self
    let swcNav = NavigationCoordinator(rootCoordinator: swc)
    swc.navigationItem.title = Lets.selectWorkout
    present(swcNav, animated: true)
    //    }
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
      } else {
        dummy.tabBarItem.image = #imageLiteral(resourceName: "show")
        dummy.tabBarItem.title = Lets.show
      }
    }
  }
}

extension MainCoordinator: SelectWorkoutCoordinatorDelegate {
  func makeActiveWorkoutCoordinator(for routine: NWorkout?)
    -> ActiveWorkoutCoordinator
  {
    activeWorkoutCoordinator = ActiveWorkoutCoordinator()
    activeWorkoutCoordinator?.delegate = self

    if let routine = routine {
      activeWorkoutCoordinator!.workout = routine.makeWorkoutWorkout()
    } else {
      activeWorkoutCoordinator!.workout = NWorkout.new(
        isComplete: false,
        name: Lets.blank
      )
    }

    activeWorkoutCoordinator!.workoutIsNotActive = { [unowned self] in
      self.activeWorkoutCoordinator = nil
    }
    return activeWorkoutCoordinator!
  }

  func selectWorkoutCoordinator(
    _ selectWorkoutCoordinator: SelectWorkoutCoordinator,
    didSelectRoutine routine: NWorkout?
  ) -> ActiveWorkoutCoordinator {
    makeActiveWorkoutCoordinator(for: routine)
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
    } else {
      return true
    }
  }
}

extension MainCoordinator: ActiveWorkoutCoordinatorDelegate {
  func hideTapped(for activeWorkoutCoordinator: ActiveWorkoutCoordinator) {
    dismiss(animated: true)
  }
}
