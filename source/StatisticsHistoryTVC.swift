import UIKit

class StatisticsHistoryTVC: BaseTVC {
  required init?(coder aDecoder: NSCoder) { fatalError() }

  init(liftName: String) {
    self.liftName = liftName
    //TODO: fill this out properly
    let lifts: [NLift] = []
    self.lifts = lifts.filter { $0.name == liftName }
      .sorted(by: { $0.workout!.startDate! < $1.workout!.startDate! })

    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  //  func setupRx() {

  //    tableView.register(StatisticsHistoryCell.self)
  //    Observable.collection(from: lifts).bind(
  //      to: tableView.rx.items(cellType: StatisticsHistoryCell.self)
  //    ) { indexPath, lift, cell in
  //
  //      cell.chartView.chartViewDataSource = BaseChartViewDataSource(object: lift)
  //      cell.dateLabel.text = cell.df.string(from: lift.workout!.startDate)
  //
  //      cell.chartView.configurationClosure = { (index, rowView) in
  //        let set = lift.object(at: index)
  //        (rowView.columnViews[0] as! UILabel).text = String(set.weight)
  //        (rowView.columnViews[1] as! UILabel).text = String(set.reps)
  //        (rowView.columnViews[2] as! UILabel).text = String(set.completedWeight)
  //        (rowView.columnViews[3] as! UILabel).text = String(set.completedReps)
  //
  //        rowView.columnViews.forEach { ($0 as! UILabel).textAlignment = .center }
  //      }
  //
  //      cell.chartView.setup()
  //      cell.setNeedsUpdateConstraints()
  //
  //    }.disposed(by: db)
  //
  //    tableView.rx.itemDeleted.subscribe(
  //      onNext: { indexPath in
  //
  //      }
  //    ).disposed(by: db)

  //  }

  let liftName: String

  var lifts: [NLift]

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
    -> CGFloat
  {
    return UITableView.automaticDimension
  }

  func tableView(
    _ tableView: UITableView,
    estimatedHeightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return UITableView.automaticDimension
  }
}
