import UIKit

class StatisticsTVC: UITableViewController {

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  weak var delegate: StatisticsTVCDelegate!

  var pairs: [(String, Int)] = []

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let lifts = JDB.shared.getLifts().filter { $0.isWorkout == true }
      .reduce([String: Int]()) {
        (dict, lift) in
        var new = dict
        new[lift.name] = (dict[lift.name] ?? 0) + 1
        return new
      }

    pairs = Array(zip(lifts.keys, lifts.values))

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

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = Theme.Colors.darkest

    tableView.tableFooterView = UIView()

    tableView.delegate = self
    tableView.separatorStyle = .none

    tableView.register(StatisticsCell.self)
    tableView.tableFooterView = UIView()
  }

  func setupRx() {
    //    tableView.dataSource = nil
    //    tableView.delegate = nil
    //    pairs.asObservable().bind(
    //      to: tableView.rx.items(
    //        cellIdentifier: StatisticsCell.reuseIdentifier,
    //        cellType: StatisticsCell.self
    //      )
    //    ) { index, pair, cell in
    //      cell.textLabel?.text = pair.0
    //      cell.detailTextLabel?.text = "\(pair.1)"
    //    }.disposed(by: db)
    //
    //    tableView.rx.modelSelected((String, Int).self).subscribe(
    //      onNext: { item in
    //        self.delegate.statisticsTVC(self, didSelectLiftType: item.0)
    //      }
    //    ).disposed(by: db)
  }
}

protocol StatisticsTVCDelegate: AnyObject {
  func statisticsTVC(
    _ statisticsTVC: StatisticsTVC,
    didSelectLiftType liftType: String
  )
}
