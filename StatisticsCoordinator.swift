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
        let slsc = SingleLiftStatisticsCoordinator()
        show(slsc, sender: self)
    }
}

import CoordinatorKit
import UIKit

class SingleLiftStatisticsCoordinator: Coordinator {
    let carbonStatisticsVC = CarbonStatisticsVC()
    override func loadViewController() {
        viewController = carbonStatisticsVC
    }
}


import CarbonKit
import UIKit

class CarbonStatisticsVC: UIViewController, CarbonTabSwipeNavigationDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let items = ["History","Charts","PR"]
        let c = CarbonTabSwipeNavigation(items: items, delegate: self)
        
        c.setTabBarHeight(44)
       
        c.setNormalColor(Theme.Colors.dark)
        c.setSelectedColor(Theme.Colors.main)
       
        c.carbonSegmentedControl?.setWidth(view.frame.width / 3, forSegmentAt: 0)
        c.carbonSegmentedControl?.setWidth(view.frame.width / 3, forSegmentAt: 1)
        c.carbonSegmentedControl?.setWidth(view.frame.width / 3, forSegmentAt: 2)
        
        c.insert(intoRootViewController: self)
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            return StatisticsHistoryTVC()
        case 1:
            return StatisticsChartsTVC()
        case 2:
            return StatisticsPersonalRecordTVC()
        default: fatalError()
        }
    }
}

class StatisticsHistoryTVC: BaseTVC {
    
}

class StatisticsChartsTVC: BaseTVC {
    
}

class StatisticsPersonalRecordTVC: BaseTVC {
    
}
