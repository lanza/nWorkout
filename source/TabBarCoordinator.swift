import UIKit

open class TabBarCoordinator: Coordinator {

  public weak var delegate: TabBarCoordinatorDelegate?

  public var tabBarController: UITabBarController {
    return viewController as! UITabBarController
  }
  private let tabBarControllerDelegateProxy = TabBarControllerDelegateProxy()

  open override func loadViewController() {
    viewController = UITabBarController()
  }

  open override func viewControllerDidLoad() {
    super.viewControllerDidLoad()

    tabBarControllerDelegateProxy.tabBarCoordinator = self
    tabBarController.delegate = tabBarControllerDelegateProxy
  }

  //Manaing the Coordinators
  public var coordinators: [Coordinator]? = [Coordinator]() {
    didSet {
      tabBarController.viewControllers = coordinators.map { unwrapped in
        unwrapped.map { coordinator in coordinator.viewController! }
      }
    }
  }

  public func setCoordinators(_ coordinators: [Coordinator]?, animated: Bool) {
    self.coordinators = coordinators
  }

  //Managing the Selected Tab
  public var selectedCoordinator: Coordinator? {
    get {
      return coordinators?[selectedIndex]
    }
    set {
      guard let coordinator = newValue else { fatalError() }
      selectedIndex = (coordinators?.firstIndex(of: coordinator))!
    }
  }

  public var selectedIndex: Int {
    get { return tabBarController.selectedIndex }
    set { tabBarController.selectedIndex = newValue }
  }

  public func addButton<T: Coordinator>(for coordinator: T, at index: Int) {
    dummyIndices.append(index)

    let dc = Coordinator()
    dc.tabBarItem.image = coordinator.tabBarItem.image
    dc.tabBarItem.title = coordinator.tabBarItem.title
    dummyCoordinators.append(dc)

    buttonCoordinators.append(coordinator)

    guard coordinators!.count > 0 else {
      fatalError("Set the coordinators property prior to adding a button")
    }
    coordinators?.insert(dc, at: index)
  }

  var dummyIndices: [Int] = []
  var dummyCoordinators: [Coordinator] = []
  var buttonCoordinators: [Coordinator] = []

  public func colorButtons(colorsAndIndices: [(color: UIColor, index: CGFloat)])
  {
    let tb = tabBarController.tabBar
    let itemWidth = tb.frame.width / CGFloat(tb.items!.count)
    for pair in colorsAndIndices {
      let backgroundView = UIView(
        frame: CGRect(
          x: itemWidth * pair.index,
          y: 0,
          width: itemWidth,
          height: tb.frame.height
        )
      )
      backgroundView.backgroundColor = pair.color
      tb.insertSubview(backgroundView, at: 0)
    }
  }

  var hasSetUpColors = false
}

public protocol TabBarButtonCoordinator: AnyObject {
  func prepareForReuse()
}

public protocol TabBarCoordinatorDelegate: AnyObject {
  func tabBarCoordinator(
    _ tabBarCoordinator: TabBarCoordinator,
    didSelect coordinator: Coordinator
  )
  func tabBarCoordinator(
    _ tabBarCoordinator: TabBarCoordinator,
    shouldSelect coordinator: Coordinator
  ) -> Bool
}
extension TabBarCoordinatorDelegate {
  public func tabBarCoordinator(
    _ tabBarCoordinator: TabBarCoordinator,
    didSelect coordinator: Coordinator
  ) {}
  public func tabBarCoordinator(
    _ tabBarCoordinator: TabBarCoordinator,
    shouldSelect coordinator: Coordinator
  ) -> Bool { return true }
}

class TabBarControllerDelegateProxy: NSObject, UITabBarControllerDelegate {
  weak var tabBarCoordinator: TabBarCoordinator!

  func tabBarController(
    _ tabBarController: UITabBarController,
    didSelect viewController: UIViewController
  ) {
    guard
      let index = tabBarController.viewControllers?.firstIndex(
        of: viewController
      )
    else { return }
    guard let coordinator = tabBarCoordinator.coordinators?[index] else {
      fatalError()
    }
    tabBarCoordinator.delegate?.tabBarCoordinator(
      tabBarCoordinator,
      didSelect: coordinator
    )
  }

  func tabBarController(
    _ tabBarController: UITabBarController,
    shouldSelect viewController: UIViewController
  ) -> Bool {
    guard
      let index = tabBarCoordinator.tabBarController.viewControllers?
        .firstIndex(of: viewController)
    else { return true }
    guard let coordinator = tabBarCoordinator.coordinators?[index] else {
      fatalError()
    }
    //MARK: - Handling dummy buttons
    if let dummyIndex = tabBarCoordinator.dummyCoordinators.firstIndex(
      of: coordinator
    ) {
      let c = tabBarCoordinator.buttonCoordinators[dummyIndex]
      (c as! TabBarButtonCoordinator).prepareForReuse()
      let cNav = NavigationCoordinator(rootCoordinator: c)
      tabBarCoordinator.present(cNav, animated: true)
      return false
    }
    //MARK: - END Handling dummy buttons
    return tabBarCoordinator.delegate?.tabBarCoordinator(
      tabBarCoordinator,
      shouldSelect: coordinator
    ) ?? true
  }
}
