import UIKit

public protocol ReusableView: AnyObject {}

extension ReusableView where Self: UIView {
  public static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UITableView {
  public func register<Cell: UITableViewCell>(_ type: Cell.Type) {
    register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
  }
}

extension UITableView {
  public func dequeueReusableCell<Cell: UITableViewCell>(
    for indexPath: IndexPath
  )
    -> Cell
  {
    guard
      let cell = dequeueReusableCell(
        withIdentifier: Cell.reuseIdentifier,
        for: indexPath
      ) as? Cell
    else { fatalError("Could not dequeue reusable cell") }
    return cell
  }
}

extension UITableViewCell: ReusableView {}
