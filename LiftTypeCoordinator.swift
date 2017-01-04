import CoordinatorKit
import UIKit
import RxSwift

class LiftTypeCoordinator: Coordinator {
    var liftTypeTVC: LiftTypeTVC { return viewController as! LiftTypeTVC }
    
    override func loadViewController() {
        viewController = LiftTypeTVC()
    }
    let db = DisposeBag()
}
