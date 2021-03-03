import Foundation

class BaseDataProvider<BaseType: AnyObject>: DataProvider {

  init(objects: [BaseType]) {
    self.objects = objects
  }

  var objects: [BaseType]

  func object(at index: Int) -> BaseType {
    return objects[index]
  }

  func numberOfItems() -> Int {
    return objects.count
  }

  func index(of object: BaseType) -> Int? {
    return objects.firstIndex(where: { $0 === object })
  }

  func append(_ object: BaseType) {
    objects.append(object)
  }

  func insert(_ object: BaseType, at index: Int) {
    objects.insert(object, at: index)
  }

  func move(from sourceIndex: Int, to destinationIndex: Int) {
    let toMove = objects.remove(at: sourceIndex)
    objects.insert(toMove, at: destinationIndex)
  }

  func remove(at index: Int) {
    objects.remove(at: index)
  }
}

extension BaseDataProvider where BaseType: NWorkout {
  func remove(at index: Int) {
    let wo = objects.remove(at: index)
    coreDataStack.getContext().delete(wo)
  }
}
