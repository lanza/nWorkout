import UIKit

protocol SelectWorkoutDelegate: class {
  func cancelSelected(for selectWorkoutVC: SelectWorkoutVC)
  func startBlankWorkoutSelected(for selectWorkoutVC: SelectWorkoutVC)

  func selectWorkoutVC(
    _ selectWorkoutVC: SelectWorkoutVC,
    selectedRoutine routine: NewWorkout
  )
}

class SelectWorkoutVC: UIViewController {

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  weak var delegate: SelectWorkoutDelegate!

  var tableView = UITableView(frame: CGRect.zero, style: .grouped)
  var startBlankWorkoutButton = StartBlankWorkoutButton.create()

  override func loadView() {
    automaticallyAdjustsScrollViewInsets = false
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
          equalTo: topLayoutGuide.bottomAnchor
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

  let objects = JDB.getWorkouts().filter { $0.isWorkout == false }

  func setupTableView() {
    tableView.register(SelectWorkoutCell.self)

    //    Observable.collection(from: objects).bind(
    //      to: tableView.rx.items(
    //        cellIdentifier: SelectWorkoutCell.reuseIdentifier,
    //        cellType: SelectWorkoutCell.self
    //      )
    //    ) { index, workout, cell in
    //      cell.configure(for: workout, at: IndexPath(row: index, section: 0))
    //    }.disposed(by: db)
    //
    //    tableView.rx.modelSelected(NewWorkout.self).subscribe(
    //      onNext: { routine in
    //        self.delegate.selectWorkoutVC(self, selectedRoutine: routine)
    //      }
    //    ).disposed(by: db)

    //        tableView.tableFooterView = UIView()
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
    setupTableView()

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

    navigationController?.setNavigationBarHidden(false, animated: false)

    tableView.reloadData()
  }
}
