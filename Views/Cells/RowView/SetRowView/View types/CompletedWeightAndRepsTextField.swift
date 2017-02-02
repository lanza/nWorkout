import UIKit

class CompletedWeightAndRepsTextField: WeightAndRepsTextField {
    override init() {
        super.init()
        
        textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }


}
