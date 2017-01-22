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
import RxDataSources

import Charts

struct ChartSectionModel {
    let things = ["hi","what"]
}
extension ChartSectionModel: SectionModelType {
    var items: [String] { return things }
    init(original: ChartSectionModel, items: [String]) {
        self.init()
    }
}

class StatisticsChartsTVC: BaseTVC {
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        super.init(nibName: nil, bundle: nil)
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<ChartSectionModel>()
    
    func setupTableView() {
        tableView.register(ChartCell.self)
        dataSource.configureCell = { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(for: ip) as ChartCell
            return cell
        }
        let sections = [ChartSectionModel()]
        Observable.just(sections).bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(db)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
   
    let db = DisposeBag()
    let liftName: String
}

class ChartCell: UITableViewCell {
    let chartView = LineChartView()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chartView)
        contentView.addConstraints([
            chartView.heightAnchor.constraint(equalToConstant: 100),
            chartView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            chartView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            chartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
}

class StatisticsPersonalRecordTVC: BaseTVC {
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        super.init(nibName: nil, bundle: nil)
    }
    
    let liftName: String
}
