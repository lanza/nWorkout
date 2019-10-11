import UIKit

class StatisticsCell: UITableViewCell {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: StatisticsCell.reuseIdentifier)

    contentView.backgroundColor = Theme.Colors.Cell.contentBackground
    backgroundColor = Theme.Colors.Table.background
    contentView.setBorder(color: .black, width: 1, radius: 3)
    //        contentView.setShadow(offsetWidth: 3, offsetHeight: 3, radius: 1, opacity: 0.7, color: .black)

    textLabel?.textColor = .white
    textLabel?.backgroundColor = .clear

    detailTextLabel?.backgroundColor = .clear
    detailTextLabel?.textColor = .white

    selectionStyle = .none
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

}
