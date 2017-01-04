import UIKit

class SelectWorkoutCell: UITableViewCell {}
extension SelectWorkoutCell: ConfigurableCell {
    func configure(for object: Workout, at indexPath: IndexPath) {
        textLabel?.text = object.name
        detailTextLabel?.text = object.lifts.map { $0.name }.joined(separator: ", ")
    }
}
