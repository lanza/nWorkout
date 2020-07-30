import UIKit

class LiftTypeCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = Theme.Colors.Table.background

    contentView.backgroundColor = Theme.Colors.Cell.contentBackground
    contentView.setBorder(color: .black, width: 1, radius: 3)
    //        contentView.setShadow(offsetWidth: 1, offsetHeight: 1, radius: 1, opacity: 0.7, color: .black)
    textLabel?.textColor = .white
    textLabel?.backgroundColor = .clear
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}

class LiftTypeTVC: BaseTVC, UITableViewDataSource {

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  var hideButtonTappedCallBack: (() -> Void)?

  @objc func hideButtonTappedForwarder() {
    hideButtonTappedCallBack?()
  }

  var newLiftButtonTappedCallBack: (() -> Void)?

  @objc func newLiftButtonTappedForwarder() {
    newLiftButtonTappedCallBack?()
  }

  init() {
    super.init(nibName: nil, bundle: nil)

    navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: Lets.hide,
      style: .plain,
      target: self,
      action: #selector(hideButtonTappedForwarder)
    )

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: Lets.newLift,
      style: .plain,
      target: self,
      action: #selector(newLiftButtonTappedForwarder)
    )
    newLiftButtonTappedCallBack = { [unowned self] in
      let alert = UIAlertController.alert(
        title: Lets.addNewLiftType,
        message: nil
      )

      let okay = UIAlertAction(title: Lets.done, style: .default) { _ in
        guard let name = alert.textFields?.first?.text else { fatalError() }
        self.liftTypes.append(name)
        self.save()
        self.tableView.reloadData()
      }
      let cancel = UIAlertAction(
        title: Lets.cancel,
        style: .cancel,
        handler: nil
      )
      alert.addAction(okay)
      alert.addAction(cancel)

      self.present(alert, animated: true, completion: nil)
    }

  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  var liftTypes: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Add Lift"

    tableView.tableFooterView = UIView()
    tableView.dataSource = self

    tableView.register(LiftTypeCell.self)

    var workoutNames: Swift.Set<String> = []
    for workout in JDB.shared.getWorkouts() {
      for lift in workout.lifts {
        workoutNames.insert(lift.name)
      }
    }
    liftTypes = [String](workoutNames)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    let cell =
      tableView.dequeueReusableCell(
        withIdentifier: LiftTypeCell.reuseIdentifier, for: indexPath)
      as! LiftTypeCell
    cell.textLabel?.text = liftTypes[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    -> Int
  {
    return liftTypes.count
  }

  override func tableView(
    _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
  ) {
    self.didSelectLiftName(liftTypes[indexPath.row])
  }

  func save() {
    UserDefaults.standard.setValue(
      self.liftTypes,
      forKey: Lets.liftTypesKey
    )
  }

  var didSelectLiftName: ((String) -> Void)!
}
