import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class StatisticsPersonalRecordTVC: BaseTVC {
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        super.init(nibName: nil, bundle: nil)
    }
    
    let liftName: String
}
