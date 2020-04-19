import UIKit

open class HamburgerCoordinator: Coordinator, HamburgerControllerDelegate {

  public var hamburgerController: HamburgerController {
    return viewController as! HamburgerController
  }

  open override func loadViewController() {
    viewController = HamburgerController()
    hamburgerController.delegate = self
  }

  public var coordinators: [Coordinator]? = [Coordinator]() {
    didSet {
      hamburgerController.viewControllers = coordinators.map { unwrapped in
        unwrapped.map { coordinator in coordinator.viewController! }
      }
    }
  }

  public func setCoordinators(_ coordinators: [Coordinator]?, animated: Bool) {
    self.coordinators = coordinators
  }

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
    get { return hamburgerController.selectedIndex }
    set { hamburgerController.selectedIndex = newValue }
  }

  open func titleFor(row: Int) -> String {
    return ""
  }
}

public protocol HamburgerControllerDelegate: class {
  func titleFor(row: Int) -> String
}

public class HamburgerController: UIViewController {

  // View controller management
  public var viewControllers: [UIViewController]? {
    get {
      return vcs
    }
    set {
      setViewControllers(newValue, animated: false)
    }
  }

  private var vcs: [UIViewController]?

  public func setViewControllers(
    _ viewControllers: [UIViewController]?,
    animated: Bool
  ) {
    self.vcs = viewControllers

    for vc in children {
      vc.willMove(toParent: nil)
      vc.removeFromParent()
    }

    selectedIndex = 0
    guard let vc = viewControllers?.first else { fatalError() }
    addChild(vc)
    vc.beginAppearanceTransition(true, animated: false)
    containerView.addSubview(vc.view)
    vc.view.frame = containerView.frame
    vc.endAppearanceTransition()
    vc.didMove(toParent: self)
    displayedViewController = vc
  }

  public var selectedViewController: UIViewController? {
    return viewControllers?[selectedIndex]
  }

  private var displayedViewController: UIViewController!

  public var selectedIndex: Int = 0 {
    didSet {
      let vc = viewControllers![selectedIndex]
      display(vc)
    }
  }

  private func display(_ viewController: UIViewController) {
    guard let dvc = displayedViewController else { return }
    guard let svc = selectedViewController else { fatalError() }
    if dvc === svc { return }
    displayedViewController = svc

    dvc.willMove(toParent: nil)
    addChild(svc)

    transition(
      from: dvc,
      to: svc,
      duration: 0.0,
      options: [],
      animations: {
        dvc.view.removeFromSuperview()
        self.containerView.addSubview(svc.view)
        svc.view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        constraints.append(
          svc.view.leftAnchor.constraint(equalTo: self.containerView.leftAnchor)
        )
        constraints.append(
          svc.view.rightAnchor.constraint(
            equalTo: self.containerView.rightAnchor
          )
        )
        constraints.append(
          svc.view.bottomAnchor.constraint(
            equalTo: self.containerView.bottomAnchor
          )
        )
        constraints.append(
          svc.view.topAnchor.constraint(equalTo: self.containerView.topAnchor)
        )
        NSLayoutConstraint.activate(constraints)
      },
      completion: { finished in
        dvc.removeFromParent()
        svc.didMove(toParent: self)
        self.closeDrawer()
      }
    )
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    tableView.selectRow(
      at: IndexPath(row: selectedIndex, section: 0),
      animated: false,
      scrollPosition: .none
    )
  }

  weak var delegate: HamburgerControllerDelegate?

  public var tableView = UITableView(frame: CGRect(), style: .plain)
  public var containerView = UIView()

  override public func viewDidLoad() {
    super.viewDidLoad()

    setupConstraints()
    setupTableView()
    setupGestureRecognizer()
  }

  var leftConstraint: NSLayoutConstraint!
  var rightConstraint: NSLayoutConstraint!

  private func setupConstraints() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    containerView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
    view.addSubview(containerView)

    var constraints = [NSLayoutConstraint]()

    constraints.append(
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
    )
    constraints.append(
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80)
    )
    constraints.append(
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    )
    constraints.append(tableView.topAnchor.constraint(equalTo: view.topAnchor))

    leftConstraint = containerView.leftAnchor.constraint(
      equalTo: view.leftAnchor
    )
    constraints.append(leftConstraint)
    rightConstraint = containerView.rightAnchor.constraint(
      equalTo: view.rightAnchor
    )
    constraints.append(rightConstraint)
    constraints.append(
      containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    )
    constraints.append(
      containerView.topAnchor.constraint(equalTo: view.topAnchor)
    )

    NSLayoutConstraint.activate(constraints)
  }

  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }

  private func setupGestureRecognizer() {
    let pgr = UIPanGestureRecognizer(
      target: self,
      action: #selector(didPan(_:))
    )
    view.addGestureRecognizer(pgr)
  }

  var originalLeftConstraintConstant: CGFloat = 0

  @objc private func didPan(_ pgr: UIPanGestureRecognizer) {

    let translation = pgr.translation(in: view)
    let velocity = pgr.velocity(in: view)

    guard translation.x + leftConstraint.constant > 0 else { return }

    if pgr.state == .began {
      originalLeftConstraintConstant = leftConstraint.constant
    } else if pgr.state == .changed {
      if leftConstraint.constant < view.frame.width - 80 {
        leftConstraint.constant = originalLeftConstraintConstant + translation.x
        rightConstraint.constant =
          originalLeftConstraintConstant
          + translation.x
      }
    } else if pgr.state == .ended {
      UIView.animate(withDuration: 0.3) {
        if velocity.x > 0 {
          self.leftConstraint.constant = self.view.frame.width - 80
          self.rightConstraint.constant = self.view.frame.width - 80
        } else {
          self.leftConstraint.constant = 0
          self.rightConstraint.constant = 0
        }
        self.view.layoutIfNeeded()
      }

    }
  }

  private func closeDrawer() {
    UIView.animate(withDuration: 0.3) {
      self.leftConstraint.constant = 0
      self.rightConstraint.constant = 0
      self.view.layoutIfNeeded()
    }
  }

  @objc func gestureRecognized(_ gr: UILongPressGestureRecognizer) {
    if gr.state == .recognized {
      grRec()
    }
  }

  open var grRec: (() -> Void)!
}

extension HamburgerController: UITableViewDataSource {

  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "cell",
      for: indexPath
    )
    cell.textLabel?.text = delegate?.titleFor(row: indexPath.row) ?? ""
    cell.backgroundColor = #colorLiteral(
      red: 0.2392156869, green: 0.6745098233,
      blue: 0.9686274529, alpha: 1)
    cell.textLabel?.textColor = #colorLiteral(
      red: 1, green: 1, blue: 1,
      alpha: 1)
    cell.textLabel?.backgroundColor = .clear

    let viewF = UIView()
    viewF.backgroundColor = #colorLiteral(
      red: 0.1019607857,
      green: 0.2784313858, blue: 0.400000006, alpha: 1)
    cell.selectedBackgroundView = viewF
    if indexPath.row == 2 {
      let gr = UILongPressGestureRecognizer(
        target: self,
        action: #selector(gestureRecognized(_:))
      )
      cell.addGestureRecognizer(gr)
    }
    return cell
  }

  public func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return viewControllers?.count ?? 0
  }

  public func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return view.frame.height / CGFloat(viewControllers!.count)
  }
}

extension HamburgerController: UITableViewDelegate {
  public func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
    cell?.textLabel?.backgroundColor = .clear
    selectedIndex = indexPath.row
  }

}
