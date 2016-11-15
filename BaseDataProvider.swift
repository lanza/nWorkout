import Foundation
import RealmSwift

class BaseDataProvider<BaseType: Base>: DataProvider {
    
    init(objects: Results<BaseType>) {
        self.objects = objects
    }
    
    let objects: Results<BaseType>
    
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
    
    func append(_ object: BaseType) { fatalError() }
    func insert(_ object: BaseType, at index: Int) { fatalError() }
    func remove(at index: Int) { fatalError() }
}
