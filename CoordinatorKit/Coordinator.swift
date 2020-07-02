import UIKit

extension Coordinator: Equatable {
  public static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
    return lhs === rhs
  }
}

public protocol CoordinatorType {
  var viewController: UIViewController! { get set }
}

open class Coordinator {
  public init() {}

  // MARK: - Managing the View Controller
  public var viewController: UIViewController! {
    set {
      if vc != nil {
        fatalError(
          "You can't change your viewController after it is initially set"
        )
      }
      vc = newValue
      vc.coordinator = self
    }
    get {
      if vc == nil {
        loadViewController()
        viewControllerDidLoad()
      }
      return vc
    }
  }

  private var vc: UIViewController!

  func loadVC() -> UIViewController {
    return UIViewController()
  }

  lazy public var viewCont: UIViewController! = {
    return self.loadVC()
  }()

  open func loadViewController() {
    viewController = UIViewController()
  }

  open func viewControllerDidLoad() {}
  open func loadViewControllerIfNeeded() { fatalError("NYI") }
  open var viewControllerIfLoaded: UIViewController? { return vc }

  public var title: String? {
    get { return viewController.title }
    set { viewController.title = newValue }
  }

  //MARK: - Presenting Coordinators
  public var modalPresentationStyle: UIModalPresentationStyle {
    get { return viewController.modalPresentationStyle }
    set { viewController.modalPresentationStyle = newValue }
  }

  public var modalTransitionStyle: UIModalTransitionStyle {
    get { return viewController.modalTransitionStyle }
    set { viewController.modalTransitionStyle = newValue }
  }

  public func show(_ coordinator: Coordinator, sender: Any?) {
    if let nc = navigationCoordinator {
      nc.pushCoordinator(coordinator, animated: true)
    } else {
      present(coordinator, animated: true)
    }
  }

  public func showDetailCoordinator(_ coordinator: Coordinator, sender: Any?) {
    fatalError("NYI")
    //        if splitViewCoordinator != nil {
    //            ///
    //        } else if let nc = navigationCoordin  ator {
    //            nc.pushCoordinator(coordinator, animated: true)
    //        } else {
    //            present(coordinator, animated: true)
    //        }
  }

  public func present(
    _ coordinatorToPresent: Coordinator,
    animated flag: Bool,
    completion: (() -> Void)? = nil
  ) {
    print(self)
    print(coordinatorToPresent)
    presentedCoordinator = coordinatorToPresent
    coordinatorToPresent.parent = self
    viewController.present(
      coordinatorToPresent.viewController,
      animated: flag,
      completion: completion
    )
  }

  public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    guard let pc = presentedCoordinator else { fatalError() }
    pc.parent = nil
    presentedCoordinator = nil
    viewController.dismiss(animated: flag, completion: completion)
  }

  public var definesPresentationContext: Bool {
    get { return viewController.definesPresentationContext }
    set { viewController.definesPresentationContext = newValue }
  }

  public var disablesAutomaticKeyboardDismissal: Bool {
    get { return viewController.disablesAutomaticKeyboardDismissal }
    set { /*viewController.disablesAutomaticKeyboardDismissal = newValue*/  }
  }

  //MARK: - Supporting Custom Transitions and Presentations
  public var transitioningDelegate: UIViewControllerTransitioningDelegate? {
    get { return viewController.transitioningDelegate }
    set { viewController.transitioningDelegate = newValue }
  }

  public var transitionCoordinator: UIViewControllerTransitionCoordinator? {
    return viewController.transitionCoordinator
  }

  public func targetCoordinator(forAction action: Selector, sender: Any?) {
    fatalError("NYI")
  }

  public var presentationController: UIPresentationController? {
    return viewController.presentationController
  }

  public var popoverPresentationController: UIPopoverPresentationController? {
    return viewController.popoverPresentationController
  }

  //MARK: - Responding to View Controller Events
  open func willNavigateToViewController(_ animated: Bool) {}

  open func didNavigateToViewController(_ animated: Bool) {}
  open func willNavigateAwayFromViewController(_ animated: Bool) {}
  open func didNavigateAwayFromViewController(_ animated: Bool) {}

  public var navigationItem: UINavigationItem {
    return viewController.navigationItem
  }
  public var tabBarItem: UITabBarItem { return viewController.tabBarItem }

  // MARK: - Getting Other Related Coordinators
  var presentingCoordinator: Coordinator? {
    didSet {}
  }

  var presentedCoordinator: Coordinator? {
    didSet {
    }
  }

  public weak var parent: Coordinator?

  public var navigationCoordinator: NavigationCoordinator? {
    if let selfNav = self as? NavigationCoordinator {
      return selfNav
    } else {
      var p = parent
      while let par = p {
        if let parentNav = par as? NavigationCoordinator {
          return parentNav
        } else {
          p = par.parent
        }
      }
    }
    return nil
  }

  public var tabBarCoordinator: TabBarCoordinator? {
    fatalError("NYI")
  }
}
