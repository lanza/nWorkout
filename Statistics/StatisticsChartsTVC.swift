import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm
import RxDataSources

import Charts

struct ChartSectionModel {
    let things = ["hi"]
}
extension ChartSectionModel: SectionModelType {
    var items: [String] { return things }
    init(original: ChartSectionModel, items: [String]) {
        self.init()
    }
}

class StatisticsChartsTVC: BaseTVC {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
   
    func doData(cell: ChartCell) {
        
        let objects = RLM.objects(type: Lift.self).filter { $0.name == self.liftName }.sorted { $0.startDate < $1.startDate }.map { return ($0.startDate.timeIntervalSinceReferenceDate,$0.sets.last?.completedWeight ?? 0) }
        
        let dataEntries = objects.map { ChartDataEntry(x:$0.0, y: $0.1) }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Progression")
        let chartData = LineChartData(dataSet: chartDataSet)
        cell.chartView.data = chartData
    }
    
    
    let dataSource = RxTableViewSectionedReloadDataSource<ChartSectionModel>()
    
    func setupTableView() {
        
        tableView.delegate = nil
        
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(ChartCell.self)
        dataSource.configureCell = { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(for: ip) as ChartCell
            self.doData(cell: cell)
            return cell
        }
        let sections = [ChartSectionModel()]
        Observable.just(sections).bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(db)
        
        tableView.rx.setDelegate(self).addDisposableTo(db)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
       
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 300),
            chartView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            chartView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            chartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        
        chartView.backgroundColor = .blue
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
}
