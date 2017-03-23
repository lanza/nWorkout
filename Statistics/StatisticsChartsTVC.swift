import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Charts

class StatisticsChartsTVC: BaseTVC {
    
    let liftName: String
    let statisticsDataProvider: StatisticsDataProvider
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    init(liftName: String) {
        self.liftName = liftName
        self.statisticsDataProvider = StatisticsDataProvider(liftName: liftName)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bestSetDataPoints = statisticsDataProvider.getBestSetDataPoints()
        let bestSetDataEntries = bestSetDataPoints.map { ChartDataEntry(x: $0.timeInterval, y: $0.weight) }
        let bestSetDataSet = LineChartDataSet(values: bestSetDataEntries, label: "Best Set Progression")
        let bestSetLineChartData = LineChartData(dataSet: bestSetDataSet)
        
        let prDataPoints = statisticsDataProvider.getPersonalRecordDataPoints()
        let prDataEntries = prDataPoints.map { ChartDataEntry(x: $0.timeInterval, y: $0.weight) }
        let prDataSet = LineChartDataSet(values: prDataEntries, label: "Personal Record Progression")
        let prLineChartData = LineChartData(dataSet: prDataSet)
        
        let sectionModel = ChartSectionModel(chartData: [bestSetLineChartData,prLineChartData])
        sections = [sectionModel]
        
        setupTableView()
    }
    
    var sections: [ChartSectionModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    let dataSource = RxTableViewSectionedReloadDataSource<ChartSectionModel>()
    
    func setupTableView() {
        
        tableView.delegate = nil
        
        //        tableView.estimatedRowHeight = 100
        //        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(ChartCell.self)
        dataSource.configureCell = { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(for: ip) as ChartCell
            cell.chartView.data = item
            
            return cell
        }
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


