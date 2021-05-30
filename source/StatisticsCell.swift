import UIKit

class StatisticsCell: UITableViewCell {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: StatisticsCell.reuseIdentifier)

    contentView.setBorder(color: .black, width: 1, radius: 3)
    //        contentView.setShadow(offsetWidth: 3, offsetHeight: 3, radius: 1, opacity: 0.7, color: .black)

    selectionStyle = .none
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

}
