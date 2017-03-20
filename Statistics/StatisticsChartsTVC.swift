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
    
    let liftName: String
    let chartDataProvider: ChartDataProvider
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        self.chartDataProvider = ChartDataProvider(liftName: liftName)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
   
    func doData(cell: ChartCell) {
        
        let chartDataPoints = chartDataProvider.getChartDataPoints()
        
        let dataEntries = chartDataPoints.map { ChartDataEntry(x:$0.timeInterval, y: $0.weight) }
        
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
}

class ChartCell: UITableViewCell {
    
    let chartView = LineChartView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            chartView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            chartView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            chartView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 300)
            ])
        
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
}
