import UIKit

class MainCoordinator: TabBarCoordinator {

  @objc func hideButtonTapped() {
    self.dismiss(animated: true)
  }

  func checkForUnfinishedWorkout(displayImmediately: Bool) {
    let request = NWorkout.getFetchRequest()
    request.fetchLimit = 10
    guard
      let fetchedWorkouts = try? coreDataStack.managedObjectContext.fetch(
        request)
    else { return }

    // TODO: do this properly with a fetch request
    let workouts = fetchedWorkouts.filter { !$0.isComplete }

    if let first = workouts.first {
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
  }

  let app: UINavigationBarAppearance = {
    let app = UINavigationBarAppearance()
    app.backgroundColor = Theme.Colors.darkest
    app.largeTitleTextAttributes = [
      NSAttributedString.Key.foregroundColor: Theme.Colors.Nav.title
    ]
    app.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: Theme.Colors.Nav.title
    ]
    return app
  }()

  func configureNavigationBarAppearance(for nav: NavigationCoordinator) {
    nav.navigationController.navigationBar.standardAppearance = app
    nav.navigationController.navigationBar.scrollEdgeAppearance = app
    nav.navigationController.navigationBar.prefersLargeTitles = true
  }

  func createCoordinators() {

    let wc = WorkoutsCoordinator()
    let wcNav = NavigationCoordinator(rootCoordinator: wc)
    wcNav.tabBarItem.image = #imageLiteral(resourceName: "workout")
    wcNav.tabBarItem.title = Lets.history
    wc.navigationItem.title = Lets.history
    configureNavigationBarAppearance(for: wcNav)

    let rc = RoutinesCoordinator()
    let rcNav = NavigationCoordinator(rootCoordinator: rc)
    rcNav.tabBarItem.image = #imageLiteral(resourceName: "routine")
    rcNav.tabBarItem.title = Lets.routines
    rc.navigationItem.title = Lets.routines
    configureNavigationBarAppearance(for: rcNav)

    let stc = StatisticsCoordinator()
    stc.tabBarItem.image = #imageLiteral(resourceName: "statistics")
    stc.tabBarItem.title = Lets.statistics
    stc.navigationItem.title = Lets.statistics

    let sec = SettingsCoordinator()
    let secNav = NavigationCoordinator(rootCoordinator: sec)
    secNav.tabBarItem.image = #imageLiteral(resourceName: "settings")
    secNav.tabBarItem.title = Lets.settings

    sec.navigationItem.title = Lets.settings
    configureNavigationBarAppearance(for: secNav)

    let coordinators = [wcNav, rcNav, dummy, stc, secNav]
    self.coordinators = coordinators

    colorButtons(colorsAndIndices: [(Theme.Colors.main, 2)])
  }

  @objc func settingsDidChange() {
    self.activeWorkoutCoordinator = nil
    self.checkForUnfinishedWorkout(displayImmediately: false)
  }

  override func viewControllerDidLoad() {
    super.viewControllerDidLoad()

    delegate = self
    Theme.configure()

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
    if JDB.shared.getWorkouts().filter({ $0.isWorkout == false }).count == 0 {
      let active = makeActiveWorkoutCoordinator(for: nil)
      let aNav = NavigationCoordinator(rootCoordinator: active)
      active.navigationItem.title = Lets.selectWorkout
      present(aNav, animated: true)
    } else {
      let swc = SelectWorkoutCoordinator()
      swc.delegate = self
      let swcNav = NavigationCoordinator(rootCoordinator: swc)
      swc.navigationItem.title = Lets.selectWorkout
      present(swcNav, animated: true)
    }
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
