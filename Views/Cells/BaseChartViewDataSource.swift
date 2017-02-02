import ChartView

class BaseChartViewDataSource<BaseType: DataProvider>: ChartViewDataSource {
    init(object: BaseType) {
        self.object = object
    }
    var object: BaseType
    var numberOfRows: Int { return object.numberOfItems() }
    var rowHeight: CGFloat { return 25 }
    var rowSpacing: CGFloat { return 1 }
    var backgroundColor: UIColor { return .clear }
}
