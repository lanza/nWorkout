import UIKit

public protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func register<Cell: UITableViewCell>(_ type: Cell.Type) where Cell: ReusableView {
        register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
}

extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell where Cell: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else { fatalError("Could not dequeue reusable cell") }
        return cell
    }
}

extension UITableViewCell: ReusableView { }
