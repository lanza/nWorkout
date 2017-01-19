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
    }
}


import CarbonKit
import UIKit

class CarbonStatisticsVC: UIViewController, CarbonTabSwipeNavigationDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = ["one","two","three"]
        let c = CarbonTabSwipeNavigation(items: items, delegate: self)
        c.insert(intoRootViewController: self)
        
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        return UIViewController()
    }
}
