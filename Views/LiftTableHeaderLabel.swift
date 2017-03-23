import UIKit

class LiftTableHeaderLabel: UILabel {
    static func create() -> LiftTableHeaderLabel {
        let l = LiftTableHeaderLabel()
        
        l.setContentCompressionResistancePriority(0, for: .horizontal)
        l.setContentCompressionResistancePriority(0, for: .vertical)
        l.setContentHuggingPriority(0, for: .horizontal)
        l.setContentHuggingPriority(0, for: .vertical)
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.numberOfLines = 0
        l.baselineAdjustment = .alignCenters
        
        l.textColor = .white
        l.backgroundColor = .clear
        
        l.setFontScaling(minimum: 1)
        
        return l
    }
}
