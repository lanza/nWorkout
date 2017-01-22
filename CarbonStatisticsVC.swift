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
import ChartView

extension Reactive where Base: UITableView {
    public func items<S: Sequence, Cell: UITableViewCell, O : ObservableType>
        (cellType: Cell.Type = Cell.self)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable
        where O.E == S, Cell: ReusableView {
            return items(cellIdentifier: cellType.reuseIdentifier, cellType: cellType)
    }
}

class StatisticsHistoryCell: ChartViewCell {
    required init?(coder aDecoder: NSCoder) { fatalError() }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        setupChartView()
        topContentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topContentView.addConstraints([
            dateLabel.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor),
            dateLabel.topAnchor.constraint(equalTo: topContentView.topAnchor)
            ])
        
        chartView.isUserInteractionEnabled = false
        
        
        
        dateLabel.numberOfLines = 0
    }
    let dateLabel = UILabel()
    let df: DateFormatter = {
        let d = DateFormatter()
        d.dateStyle = .medium
        d.timeStyle = .medium
        return d
    }()
    
   
    func setupChartView() {
        chartView.register(StatisticsHistorySetRowView.self, forResuseIdentifier: "row")
    }
}

class StatisticsHistorySetRowView: RowView {
    required init() {
        super.init()
        columnViewTypes = [UILabel.self, UILabel.self, UILabel.self, UILabel.self]
        columnWidths = [25,25,25,25]
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}


class StatisticsHistoryTVC: BaseTVC {
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        self.lifts = RLM.objects(type: Lift.self).filter("name == %@", liftName).sorted(byProperty: "startDate", ascending: false)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRx()
    }
    
    func setupRx() {
        
        tableView.register(StatisticsHistoryCell.self)
        Observable.from(lifts).bindTo(tableView.rx.items(cellType: StatisticsHistoryCell.self)) { indexPath, lift, cell in
            
            cell.chartView.chartViewDataSource = BaseChartViewDataSource(object: lift)
            cell.dateLabel.text = cell.df.string(from: lift.startDate)
            
            cell.chartView.configurationClosure = { (index,rowView) in
                let set = lift.object(at: index)
                (rowView.columnViews[0] as! UILabel).text = String(set.weight)
                (rowView.columnViews[1] as! UILabel).text = String(set.reps)
                (rowView.columnViews[2] as! UILabel).text = String(set.completedWeight)
                (rowView.columnViews[3] as! UILabel).text = String(set.completedReps)
                
                rowView.columnViews.forEach { ($0 as! UILabel).textAlignment = .center }
            }
            
            cell.chartView.setup()
            cell.setNeedsUpdateConstraints()
            
            }.addDisposableTo(db)
    
        tableView.rx.itemDeleted.subscribe(onNext: { indexPath in
            
        }).addDisposableTo(db)
        
    }
    
    let liftName: String
    let lifts: Results<Lift>
    
    let db = DisposeBag()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
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
