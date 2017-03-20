import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm
import ChartView
import Reuse

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
        setupTopContentView()
        
        
        chartView.isUserInteractionEnabled = false
        
        
        contentView.backgroundColor = Theme.Colors.dark
        contentView.setShadow(offsetWidth: 3, offsetHeight: 3, radius: 1, opacity: 0.7, color: .black)
        
        dateLabel.numberOfLines = 0
    }
    
    func setupTopContentView() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        topContentView.addSubview(dateLabel)
        
        setHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        topContentView.addSubview(header)
        
        topContentView.addConstraints([
            dateLabel.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
            dateLabel.topAnchor.constraint(equalTo: topContentView.topAnchor),
            
            header.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor),
            header.leftAnchor.constraint(equalTo: topContentView.leftAnchor),
            header.rightAnchor.constraint(equalTo: topContentView.rightAnchor),
            header.heightAnchor.constraint(equalToConstant: 18),
            header.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5)

            ])
    }
    func setHeader() {
        header = StatisticsHistoryTableHeaderView()
    }
    var header: LiftTableHeaderView!
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        return l
    }()
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
        columnBackgroundColor = Theme.Colors.darkest
        columnViewTypes = [DarkLabel.self, DarkLabel.self, DarkLabel.self, DarkLabel.self]
        columnWidths = [25,25,25,25]
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}


class StatisticsHistoryTVC: BaseTVC {
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        self.lifts = RLM.objects(type: Lift.self).filter("name == %@", liftName).filter("isWorkout == true").sorted(byKeyPath   : "workout.startDate", ascending: false)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRx()
    }
    
    func setupRx() {
        
        tableView.register(StatisticsHistoryCell.self)
        Observable.collection(from: lifts).bindTo(tableView.rx.items(cellType: StatisticsHistoryCell.self)) { indexPath, lift, cell in
            
            cell.chartView.chartViewDataSource = BaseChartViewDataSource(object: lift)
            cell.dateLabel.text = cell.df.string(from: lift.workout!.startDate)
            
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
