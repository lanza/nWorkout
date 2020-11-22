import Foundation
import UIKit

protocol DataProvider {
  associatedtype Object

  func object(at index: Int) -> Object
  func numberOfItems() -> Int

  func append(_ object: Object)
  func insert(_ object: Object, at index: Int)
  func remove(at index: Int)
  func index(of object: Object) -> Int?

  func move(from sourceIndex: Int, to destinationIndex: Int)
}

extension DataProvider {
  func move(from sourceIndex: Int, to destinationIndex: Int) {
    let move = object(at: sourceIndex)
    remove(at: sourceIndex)
    insert(move, at: destinationIndex)
  }
}
