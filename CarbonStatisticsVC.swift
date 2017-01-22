import CarbonKit
import UIKit



class CarbonStatisticsVC: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        super.init(nibName: nil, bundle: nil)
        title = liftName
    }
    
    let liftName: String
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
            return StatisticsHistoryTVC(liftName: liftName)
        case 1:
            return StatisticsChartsTVC(liftName: liftName)
        case 2:
            return StatisticsPersonalRecordTVC(liftName: liftName)
        default: fatalError()
        }
    }
}

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

import Charts
import ChartsRealm

class StatisticsChartsTVC: BaseTVC {
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        super.init(nibName: nil, bundle: nil)
    }
    
    func setupTableView() {
        tableView.register(ChartCell.self)
        Observable.just(["hi"])
    }
    
    let liftName: String
}

class ChartCell: UITableViewCell {
    let chartView = LineChartView()
    init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let set = 3
    }
    
}

class StatisticsPersonalRecordTVC: BaseTVC {
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        super.init(nibName: nil, bundle: nil)
    }
    
    let liftName: String
}
