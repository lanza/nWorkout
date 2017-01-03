import UIKit

class SelectWorkoutCell: UITableViewCell {}
extension SelectWorkoutCell: ConfigurableCell {
    static var identifier: String { return "SelectWorkoutCell" }
    func configure(for object: Workout, at indexPath: IndexPath) {
        textLabel?.text = object.name
        detailTextLabel?.text = object.lifts.map { $0.name }.joined(separator: ", ")
    }
}
