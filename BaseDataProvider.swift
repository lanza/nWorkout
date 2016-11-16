import Foundation
import RealmSwift

class BaseDataProvider<BaseType: Base>: DataProvider {
    
    init(objects: Results<BaseType>) {
        self.objects = Array(objects)
    }
    
    var objects: [BaseType]
    
    func object(at index: Int) -> BaseType {
        print("Workouts data provider")
        return objects[index]
    }
    func numberOfItems() -> Int {
        return objects.count
    }
    func index(of object: BaseType) -> Int? {
        return objects.index(of: object)
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
        RLM.write {
            RLM.realm.delete(object(at: index))
            objects.remove(at: index)
        }
    }
}
