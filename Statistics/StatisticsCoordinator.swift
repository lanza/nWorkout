import SwiftUI
import UIKit

class StatisticsCoordinator: Coordinator {

  var statisticsTVC: StatisticsTVC { return viewController as! StatisticsTVC }

  override func loadViewController() {
    let hostingVC = UIHostingController(
      rootView: StatisticsView(workouts: []))
    hostingVC.view.backgroundColor = Theme.Colors.darkest
    viewController = hostingVC
    //    statisticsTVC.delegate = self
  }
}

extension StatisticsCoordinator: StatisticsTVCDelegate {
  func statisticsTVC(
    _ statisticsTVC: StatisticsTVC,
    didSelectLiftType liftType: String
  ) {
    let slsc = SingleLiftStatisticsCoordinator(liftName: liftType)
    show(slsc, sender: self)
  }
}
