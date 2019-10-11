import ChartView
import UIKit

class StatisticsHistoryCell: ChartViewCell {
  required init?(coder aDecoder: NSCoder) { fatalError() }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupChartView()
    setupTopContentView()

    chartView.isUserInteractionEnabled = false

    contentView.backgroundColor = Theme.Colors.Cell.contentBackground
    backgroundColor = Theme.Colors.Table.background
    contentView.setBorder(color: .black, width: 1, radius: 3)
    //        contentView.setShadow(offsetWidth: 3, offsetHeight: 3, radius: 1, opacity: 0.7, color: .black)

    dateLabel.numberOfLines = 0
  }

  func setupTopContentView() {
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    topContentView.addSubview(dateLabel)

    setHeader()
    header.translatesAutoresizingMaskIntoConstraints = false
    topContentView.addSubview(header)

    topContentView.addConstraints(
      [
        dateLabel.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
        dateLabel.topAnchor.constraint(equalTo: topContentView.topAnchor),

        header.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor),
        header.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
        header.rightAnchor.constraint(equalTo: topContentView.rightAnchor),
        header.heightAnchor.constraint(equalToConstant: 18),
        header.topAnchor.constraint(
          equalTo: dateLabel.bottomAnchor,
          constant: 5
        ),

      ]
    )
  }

  func setHeader() {
    header = LiftTableHeaderView(type: .statisticsHistory)
  }

  var header: LiftTableHeaderView!

  let dateLabel: UILabel = {
    let l = UILabel()
    l.textColor = .white
    return l
  }()

  let df: DateFormatter = {
    let d = DateFormatter()
    d.dateStyle = .medium
    d.timeStyle = .medium
    return d
  }()

  func setupChartView() {
    chartView.register(
      StatisticsHistorySetRowView.self,
      forResuseIdentifier: "row"
    )
  }

}
