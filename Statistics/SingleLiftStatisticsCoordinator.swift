import CoordinatorKit
import UIKit

class SingleLiftStatisticsCoordinator: Coordinator {
  let liftName: String

  init(liftName: String) {
    self.liftName = liftName
    super.init()
  }

  var carbonStatisticsVC: CarbonStatisticsVC {
    return viewController as! CarbonStatisticsVC
  }

  override func loadViewController() {
    viewController = CarbonStatisticsVC(liftName: liftName)
  }
}
