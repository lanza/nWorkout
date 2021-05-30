import UIKit

class SingleLiftStatisticsCoordinator: Coordinator {
  let liftName: String

  init(liftName: String) {
    self.liftName = liftName
    super.init()
  }
}
