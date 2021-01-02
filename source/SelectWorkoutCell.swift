import UIKit

class SelectWorkoutCell: UITableViewCell {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    contentView.backgroundColor = Theme.Colors.Cell.contentBackground
    textLabel?.textColor = .white
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

}
extension SelectWorkoutCell: ConfigurableCell {
  func configure(for object: NWorkout, at indexPath: IndexPath) {
    textLabel?.text = object.name
    var string = ""
    for lift in object.lifts! {
      let l = lift as! NLift
      string += l.getName() + ", "
    }
    string.removeLast(2)
    detailTextLabel?.text = string
  }
}
