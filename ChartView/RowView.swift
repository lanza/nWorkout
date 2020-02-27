import UIKit

open class RowView: UIView {
    required public init() {
        super.init(frame: CGRect.zero)
    }
    required public init?(coder aDecoder: NSCoder) { fatalError() }
    
    open func prepareForReuse() { 
    }
    
    public var columnViews: [UIView] = []
    open var columnViewTypes: [UIView.Type] = [UILabel.self, UILabel.self]
    open var columnWidths: [CGFloat] = [50,50]
    
    public var numberOfColumns: Int { return columnViewTypes.count }
    public var columnBackgroundColor: UIColor = .white
    public var columnSpacing: CGFloat = 1
    
    public func appendColumnView(_ columnView: UIView) {
        columnViews.append(columnView)
        columnView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(columnView)
    }
    
    open func getColumnView(columnNumber: Int) -> UIView {
        return columnViewTypes[columnNumber].init()
    }
    
    open func setupColumns() {
        
        var constraints = [NSLayoutConstraint]()
        
        for columnNumber in 0..<numberOfColumns {
            let cv = getColumnView(columnNumber: columnNumber)
            
            appendColumnView(cv)
            
            cv.backgroundColor = columnBackgroundColor
            
          cv.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 0), for: .horizontal)
            constraints.append(cv.topAnchor.constraint(equalTo: topAnchor, constant: 0))
            constraints.append(cv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0))
            
            if columnNumber == 0 {
                constraints.append(cv.leftAnchor.constraint(equalTo: leftAnchor))
            } else {
                constraints.append(cv.leftAnchor.constraint(equalTo: columnViews[columnNumber - 1].rightAnchor, constant: columnSpacing))
            }
        
        }
        if let last = columnViews.last {
            let constraint = last.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
          constraint.priority = UILayoutPriority(rawValue: 1000)
            constraints.append(constraint)
        }
        
        for i in 1..<numberOfColumns {
            let first = columnViews[i-1]
            let fwm = columnWidths[i-1]
            let second = columnViews[i]
            let swm = columnWidths[i]
            constraints.append(first.widthAnchor.constraint(equalTo: second.widthAnchor, multiplier: fwm/swm))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}
