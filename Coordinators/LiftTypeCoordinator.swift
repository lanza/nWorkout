import CoordinatorKit
import RxSwift
import UIKit

class LiftTypeCoordinator: Coordinator {
  var liftTypeTVC: LiftTypeTVC { return viewController as! LiftTypeTVC }

  override func loadViewController() {
    viewController = LiftTypeTVC()
  }

  let db = DisposeBag()
}
