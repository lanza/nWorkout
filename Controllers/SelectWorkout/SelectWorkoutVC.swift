import UIKit

protocol SelectWorkoutDelegate: class {
  func cancelSelected(for selectWorkoutVC: SelectWorkoutVC)
  func startBlankWorkoutSelected(for selectWorkoutVC: SelectWorkoutVC)

  func selectWorkoutVC(
    _ selectWorkoutVC: SelectWorkoutVC,
    selectedRoutine routine: NewWorkout
  )
}

class SelectWorkoutVC: UIViewController, UITableViewDataSource,
  UITableViewDelegate
{

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  weak var delegate: SelectWorkoutDelegate!

  var tableView = UITableView(frame: CGRect.zero, style: .grouped)
  var startBlankWorkoutButton = StartBlankWorkoutButton.create()

  override func loadView() {
    tableView.contentInsetAdjustmentBehavior = .never
    view = UIView(frame: AppDelegate.main.window!.frame)
    view.backgroundColor = Theme.Colors.darkest
  }

  func setupView() {
    view.addSubview(tableView)
    view.addSubview(startBlankWorkoutButton)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    startBlankWorkoutButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        startBlankWorkoutButton.topAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.topAnchor
        ),
        startBlankWorkoutButton.leftAnchor.constraint(
          equalTo: view.layoutMarginsGuide.leftAnchor
        ),
        startBlankWorkoutButton.rightAnchor.constraint(
          equalTo: view.layoutMarginsGuide.rightAnchor
        ),
        tableView.topAnchor.constraint(
          equalTo: startBlankWorkoutButton.bottomAnchor,
          constant: 8
        ),
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      ]
    )
  }

  let objects = JDB.shared.getWorkouts().filter { $0.isWorkout == false }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    -> Int
  {
    return objects.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    let cell =
      tableView.dequeueReusableCell(
        withIdentifier: SelectWorkoutCell.reuseIdentifier) as! SelectWorkoutCell
    let nwo = objects[indexPath.row]
    cell.configure(for: nwo, at: indexPath)
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    let routine = objects[indexPath.row]
    self.delegate.selectWorkoutVC(self, selectedRoutine: routine)
  }

  @objc func startBlankWorkoutButtonTapped() {
    self.delegate.startBlankWorkoutSelected(for: self)
  }

  @objc func cancelButtonTapped() {
    self.delegate.cancelSelected(for: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
    tableView.register(SelectWorkoutCell.self)
    tableView.tableFooterView = UIView()
    tableView.delegate = self
    tableView.dataSource = self

    startBlankWorkoutButton.addTarget(
      self, action: #selector(startBlankWorkoutButtonTapped),
      for: .touchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: Lets.cancel,
      style: .plain,
      target: self,
      action: #selector(cancelButtonTapped)
    )
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    tableView.reloadData()
  }
}
