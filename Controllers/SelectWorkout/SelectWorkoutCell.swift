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
    func configure(for object: Workout, at indexPath: IndexPath) {
        textLabel?.text = object.name
        detailTextLabel?.text = object.lifts.map { $0.name }.joined(separator: ", ")
    }
}
