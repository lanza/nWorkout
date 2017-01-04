import Foundation

protocol ConfigurableCell {
    associatedtype Object
    func configure(for object: Object, at indexPath: IndexPath)
}
