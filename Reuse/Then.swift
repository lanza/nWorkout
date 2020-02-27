import Foundation

public protocol Then {}

public extension Then where Self: Any {
  func with(_ configuration: (inout Self) -> Void) -> Self {
    var copy = self
    configuration(&copy)
    return copy
  }

  func `do`(_ configuration: (Self) -> Void) {
    configuration(self)
  }
}

public extension Then where Self: AnyObject {
  func then(_ configuration: (Self) -> Void) -> Self {
    configuration(self)
    return self
  }
}

extension NSObject: Then {}
