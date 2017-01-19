import UIKit

class WeightAndRepsLabelHolder: UIView {
    let warl = WeightAndRepsLabel()
    var text: String? {
        didSet {
            warl.text = text
        }
    }
    init() {
        super.init(frame: .zero)
        
        warl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(warl)
        
        NSLayoutConstraint.activate([
            warl.leftAnchor.constraint(equalTo: leftAnchor, constant: 3),
            warl.rightAnchor.constraint(equalTo: rightAnchor, constant: -3),
            warl.topAnchor.constraint(equalTo: topAnchor),
            warl.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

class WeightAndRepsLabel: UILabel {
    fileprivate init() {
        super.init(frame: CGRect.zero)
        
        textAlignment = .center
        numberOfLines = 0
        baselineAdjustment = .alignCenters
        
        textColor = .lightGray
        
        setFontScaling(minimum: 4)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
