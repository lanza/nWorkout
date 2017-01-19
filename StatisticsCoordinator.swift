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

import CoordinatorKit
import UIKit

class SingleLiftStatisticsCoordinator: Coordinator {
    let liftName: String
    init(liftName: String) {
        self.liftName = liftName
        super.init()
    }
    
    var carbonStatisticsVC: CarbonStatisticsVC { return viewController as! CarbonStatisticsVC }
    
    override func loadViewController() {
        viewController = CarbonStatisticsVC(liftName: liftName)
    }
}


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

class StatisticsHistoryTVC: BaseTVC {
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lifts = RLM.realm.objects(Lift.self).filter("name == %@", liftName)
        setupRx()
    }
    
    func setupRx() {
        tableView.register(UITableViewCell.self)
        Observable.from(lifts).bindTo(tableView.rx.items(cellIdentifier: UITableViewCell.reuseIdentifier, cellType: UITableViewCell.self)) { index, item, cell in
            
            cell.textLabel?.text = String(describing:item.sets.count)
            
        }.addDisposableTo(db)
    }
    
    let liftName: String
    var lifts: Results<Lift>!
    
    let db = DisposeBag()
}

class StatisticsChartsTVC: BaseTVC {
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        super.init(nibName: nil, bundle: nil)
    }
    
    let liftName: String
}

class StatisticsPersonalRecordTVC: BaseTVC {
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        super.init(nibName: nil, bundle: nil)
    }
    
    let liftName: String
}
