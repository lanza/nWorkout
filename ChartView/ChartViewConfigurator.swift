import UIKit

public struct ChartViewConfigurator: ChartViewDataSource {
    
    public var rowHeight: CGFloat
    public var numberOfRows: Int
    public var rowSpacing: CGFloat
    public var backgroundColor: UIColor
    
    public init(rowHeight: CGFloat, numberOfRows: Int, rowSpacing: CGFloat, backgroundColor: UIColor) {
        self.rowHeight = rowHeight
        self.numberOfRows = numberOfRows
        self.rowSpacing = rowSpacing
        self.backgroundColor = backgroundColor
    }
}

public protocol ChartViewDataSource {
    var rowHeight: CGFloat { get }
    var numberOfRows: Int { get }
    var rowSpacing: CGFloat { get }
    var backgroundColor: UIColor { get }
}

public extension ChartViewDataSource {
    var rowHeight: CGFloat { return 35 }
    var numberOfRows: Int { return 0 }
    var rowSpacing: CGFloat { return 2 }
    var backgroundColor: UIColor { return .white }
}

