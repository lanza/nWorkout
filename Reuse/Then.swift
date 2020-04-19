import Foundation

public protocol Then {}

extension Then where Self: Any {
  public func with(_ configuration: (inout Self) -> Void) -> Self {
    var copy = self
    configuration(&copy)
    return copy
  }

  public func `do`(_ configuration: (Self) -> Void) {
    configuration(self)
  }
}

extension Then where Self: AnyObject {
  public func then(_ configuration: (Self) -> Void) -> Self {
    configuration(self)
    return self
  }
}

extension NSObject: Then {}
