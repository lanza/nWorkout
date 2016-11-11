import Foundation
import RealmSwift

class WorkoutsDataProvider: DataProvider {
    
    init() {
        objects = realm.objects(Workout.self)
    }
    
    let realm = try! Realm()
    let objects: Results<Workout>
    
    func object(at index: Int) -> Workout {
        return objects[index]
    }
    func numberOfItems() -> Int {
        return objects.count
    }
    func index(of object: Workout) -> Int? {
        return objects.index(of: object)
    }
    
    func append(_ object: Workout) { fatalError() }
    func insert(_ object: Workout, at index: Int) { fatalError() }
    func remove(at index: Int) { fatalError() }
}
