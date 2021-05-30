import UIKit

extension WorkoutCell: ConfigurableCell {}

class WorkoutCell: ChartViewCell {
  func configure(for object: NWorkout, at indexPath: IndexPath) {

    chartView.chartViewDataSource = BaseChartViewDataSource(object: object)

    label.text = Lets.workoutDateDF.string(from: object.startDate!)

    chartView.configurationClosure = { (index, rowView) in
      let lift = object.object(at: index)
      (rowView.columnViews[0] as! UILabel).text = lift.getName()
      (rowView.columnViews[0] as! UILabel).textAlignment = .center
      (rowView.columnViews[1] as! UILabel).text =
        String(lift.sets!.count)
        + " sets"
      (rowView.columnViews[1] as! UILabel).textAlignment = .center
    }

    chartView.setup()
    setNeedsUpdateConstraints()
  }

  let label = UILabel()

  func setupContentView() {
    contentView.setBorder(color: .black, width: 1, radius: 3)

    //        contentView.setShadow(offsetWidth: 3, offsetHeight: 3, radius: 1, opacity: 0.7, color: .black)
  }

  func setupTopContentView() {
    label.translatesAutoresizingMaskIntoConstraints = false
    topContentView.addSubview(label)

    NSLayoutConstraint.activate(
      [
        label.topAnchor.constraint(equalTo: topContentView.topAnchor),
        label.leftAnchor.constraint(
          equalTo: topContentView.leftAnchor,
          constant: 4
        ),
        label.rightAnchor.constraint(
          equalTo: topContentView.rightAnchor,
          constant: -4
        ),
        label.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor),
      ]
    )
  }

  func setupBottomContentView() {}

  func setupChartView() {
    chartView.emptyText = "This workout is empty"

    chartView.register(WorkoutCellRowView.self, forResuseIdentifier: "row")
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    chartView.isUserInteractionEnabled = false

    setupTopContentView()
    setupBottomContentView()
    setupChartView()
    setupContentView()
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}
