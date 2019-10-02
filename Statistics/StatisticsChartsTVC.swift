import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Charts

class CustomLineChartDataSet: LineChartDataSet {
    override init(entries values: [ChartDataEntry]?, label: String?) {
        super.init(entries: values, label: label)
        
        circleColors = [Theme.Colors.main]
        circleRadius = 5
        circleHoleRadius = 3
        
        colors = [Theme.Colors.main]
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

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
        let bestSetDataSet = CustomLineChartDataSet(entries: bestSetDataEntries, label: "Best Set Progression")
        let bestSetLineChartData = LineChartData(dataSet: bestSetDataSet)
        
        let prDataPoints = statisticsDataProvider.getPersonalRecordDataPoints()
        let prDataEntries = prDataPoints.map { ChartDataEntry(x: $0.timeInterval, y: $0.weight) }
        let prDataSet = CustomLineChartDataSet(entries: prDataEntries, label: "Personal Record Progression")
        let prLineChartData = LineChartData(dataSet: prDataSet)
        
        let sectionModel = ChartSectionModel(chartData: [bestSetLineChartData,prLineChartData])
        sections = [sectionModel]
        
        setupTableView()
    }
    
    var sections: [ChartSectionModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
  let dataSource = RxTableViewSectionedReloadDataSource<ChartSectionModel>(configureCell: { ds, tv, ip, item in
    let cell = tv.dequeueReusableCell(for: ip) as ChartCell
    cell.chartView.data = item
    
    return cell
  })
    
    func setupTableView() {
        tableView.allowsSelection = false
        
        tableView.delegate = nil
        
        //        tableView.estimatedRowHeight = 100
        //        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(ChartCell.self)
      Observable.just(sections).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: db)
      tableView.rx.setDelegate(self).disposed(by: db)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    let db = DisposeBag()
}


