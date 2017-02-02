import Foundation

class ArrayProvider<Type: Equatable>: DataProvider {
    init(array: [Type]) {
        self.objects = array
    }
    var objects: [Type]
    
    func numberOfItems() -> Int {
        return objects.count
    }
    func object(at index: Int) -> Type {
        return objects[index]
    }
    func append(_ object: Type) {
        objects.append(object)
    }
    func insert(_ object: Type, at index: Int) {
        objects.insert(object, at: index)
    }
    func remove(at index: Int) {
        objects.remove(at: index)
    }
    func index(of object: Type) -> Int? {
        return objects.index(of: object)
    }
}
