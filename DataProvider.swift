import Foundation

protocol DataProvider {
    associatedtype Object
    
    func object(at index: Int) -> Object
    func numberOfItems() -> Int
    
    func insert(object: Object, at index: Int)
    func remove(at index: Int)
    func index(of object: Object) -> Int?
    
    func move(from sourceIndex: Int, to destinationIndex: Int)
}

extension DataProvider {
    func move(from sourceIndex: Int, to destinationIndex: Int) {
        let move = object(at: sourceIndex)
        remove(at: sourceIndex)
        insert(object: move, at: destinationIndex)
    }
}

// extension where Self: CollectionType or RealmCollectionType


func q() {
    var q = [1,2]
    q.remove(at: 0)
}
