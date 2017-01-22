import UIKit
import CoordinatorKit

class StatisticsCoordinator: Coordinator {
    
    var statisticsTVC: StatisticsTVC { return viewController as! StatisticsTVC }
    
    override func loadViewController() {
        viewController = StatisticsTVC()
        statisticsTVC.delegate = self
    }
}

extension StatisticsCoordinator: StatisticsTVCDelegate {
    func statisticsTVC(_ statisticsTVC: StatisticsTVC, didSelectLiftType liftType: String) {
        let slsc = SingleLiftStatisticsCoordinator(liftName: liftType)
        show(slsc, sender: self)
    }
}





