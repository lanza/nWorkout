import UIKit

class LiftTypeCoordinator: Coordinator {
  var liftTypeTVC: LiftTypeTVC { return viewController as! LiftTypeTVC }

  override func loadViewController() {
    viewController = LiftTypeTVC()
  }
}
