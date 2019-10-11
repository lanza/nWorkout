import Reuse
import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UITableView {
  public func items<S: Sequence, Cell: UITableViewCell, O: ObservableType>(
    cellType: Cell.Type = Cell.self
  )
    -> (_ source: O)
    -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
    -> Disposable
  where O.Element == S {
    return items(cellIdentifier: cellType.reuseIdentifier, cellType: cellType)
  }
}
