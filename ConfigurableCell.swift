import Foundation

protocol ConfigurableCell {
    associatedtype Object
    static var identifier: String { get }
    func configure(for object: Object, at indexPath: IndexPath)
}
