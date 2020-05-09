import UIKit

class BaseWorkoutTVC<Cell: LiftCell>: UIViewController, UITableViewDelegate,
  WorkoutDataSourceDelegate, CustomIOSAlertViewDelegate,
  WorkoutFooterViewDelegate
where Cell.Object == NewLift {

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    tableView.setEditing(editing, animated: animated)
  }

  let tableView = UITableView()

  var dataSource: WorkoutDataSource<Cell>!
  var workout: NewWorkout!

  var keyboardHandler: KeyboardHandler!

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    Keyboard.shared.delegate = dataSource.textFieldBehaviorHandler

    if tabBarController != nil {
      let ci = tableView.contentInset
      tableView.contentInset = UIEdgeInsets(
        top: ci.top,
        left: ci.left,
        bottom: 49,
        right: ci.right
      )
    }
  }

  func setDataSource() {
    fatalError()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = Theme.Colors.darkest

    let v = UIView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: UIApplication.shared.windows[0].frame.width,
        height: 64
      )
    )
    v.backgroundColor = Theme.Colors.darkest
    view.addSubview(v)
    v.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        v.topAnchor.constraint(equalTo: view.topAnchor),
        v.leftAnchor.constraint(equalTo: view.leftAnchor),
        v.rightAnchor.constraint(equalTo: view.rightAnchor),
        v.heightAnchor.constraint(equalToConstant: 64),

        tableView.topAnchor.constraint(equalTo: v.bottomAnchor),
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        tableView.bottomAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.bottomAnchor
        ),
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
      ]
    )

    tableView.tableFooterView = UIView()
    navigationItem.rightBarButtonItem = editButtonItem

    view.backgroundColor = Theme.Colors.darkest
    tableView.delegate = self
    tableView.separatorStyle = .none

    setDataSource()
    dataSource.delegate = self

    navigationItem.rightBarButtonItem = editButtonItem

    keyboardHandler = KeyboardHandler.new(tableView: tableView, view: view)

    NotificationCenter.default.addObserver(
      self, selector: #selector(observeChartViewWillDeleteNotification),
      name: Notification.Name(
        rawValue: Lets.chartViewWillDeleteNotificationName), object: nil)

    NotificationCenter.default.addObserver(
      self, selector: #selector(observeChartViewDidDeleteNotification),
      name: Notification.Name(
        rawValue: Lets.chartViewDidDeleteNotificationName), object: nil)

    dataSource.workoutFooterView.delegate = self
  }

  @objc func observeChartViewWillDeleteNotification() {
    self.tableView.beginUpdates()
  }

  @objc func observeChartViewDidDeleteNotification() {
    self.tableView.endUpdates()
  }

  func addNewLift(name: String) {
    let lift = workout.addNewLift(name: name)

    let index = workout.index(of: lift)!
    let indexPath = IndexPath(row: index, section: 0)
    self.tableView.insertRows(at: [indexPath], with: .automatic)
  }

  var didTapAddNewLift: (() -> Void)!

  func setRowView(_ setRowView: SetRowView, didTapNoteButtonForSet set: NewSet)
  {
    let a = CustomIOSAlertView()
    //    a?.containerView = NoteView.new(for: set, view: setRowView)
    a?.delegate = self
    a?.show()
  }

  func liftCell(_ liftCell: LiftCell, didTapNoteButtonForLift lift: NewLift) {
    let a = CustomIOSAlertView()
    //    a?.containerView = NoteView.new(for: lift, view: liftCell)
    a?.delegate = self
    a?.show()
  }

  func customIOS7dialogButtonTouchUp(
    inside alertView: Any!,
    clickedButtonAt buttonIndex: Int
  ) {
    let av = alertView as! CustomIOSAlertView
    //    if let nv = av.containerView as? NoteView<Set, SetRowView> {
    //      nv.type.note = nv.textView.text
    //      nv.view.noteButton?.update(for: nv.type)
    //    } else if let nv = av.containerView as? NoteView<Lift, LiftCell> {
    //      nv.type.note = nv.textView.text
    //      nv.view.noteButton.update(for: nv.type)
    //    }
    av.close()
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    UIResponder.currentFirstResponder?.resignFirstResponder()
  }

  func addLiftTapped() {
    self.didTapAddNewLift()
  }

  func cancelWorkoutTapped() {
  }

  func finishWorkoutTapped() {
  }

  func workoutDetailTapped() {
  }
}
