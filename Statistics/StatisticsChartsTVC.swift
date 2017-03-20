import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm
import RxDataSources

import Charts

struct ChartSectionModel {
    let chartData: [LineChartData]
}
extension ChartSectionModel: SectionModelType {
    var items: [LineChartData] { return chartData }
    init(original: ChartSectionModel, items: [LineChartData]) {
        self.chartData = items
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
        
        let bestSetDataPoints = chartDataProvider.getBestSetDataPoints()
        let bestSetDataEntries = bestSetDataPoints.map { ChartDataEntry(x: $0.timeInterval, y: $0.weight) }
        let bestSetDataSet = LineChartDataSet(values: bestSetDataEntries, label: "Best Set Progression")
        let bestSetLineChartData = LineChartData(dataSet: bestSetDataSet)
        
        let prDataPoints = chartDataProvider.getPersonalRecordDataPoints()
        let prDataEntries = prDataPoints.map { ChartDataEntry(x: $0.timeInterval, y: $0.weight) }
        let prDataSet = LineChartDataSet(values: prDataEntries, label: "Personal Record Progression")
        let prLineChartData = LineChartData(dataSet: prDataSet)
        
        let sectionModel = ChartSectionModel(chartData: [bestSetLineChartData,prLineChartData])
        sections = [sectionModel]
        
        setupTableView()
    }
    
//    func test() {
//        let point = ChartDataPair(timeInterval: 0, weight: 0)
//        let entry = ChartDataEntry(x: point.timeInterval, y: point.weight)
//        let set = LineChartDataSet(values: [entry], label: "Test")
//        let data = LineChartData(dataSet: set)
//        
//        let chart = LineChartView()
//        
//        let blcvb = chart as! BarLineChartViewBase
//        let xaxis = blcvb.xAxis
//        
//        
//        let x = XAxis()
//        let a = AxisBase()
//        
//    }
    
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

class ChartCell: UITableViewCell {
    
    let chartView = LineChartView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
        setupChartView()
        
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func setupConstraints() {
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
    
    func setupChartView() {
        chartView.xAxis.valueFormatter = xAxisFormatter
        
//        chartView.xAxis.axisLineWidth = 1
//        chartView.xAxis.gridLineWidth = 3
        
    }
    
    let xAxisFormatter = XAxisFormatter()
    
    class XAxisFormatter: NSObject, IAxisValueFormatter {
        
        let df: DateFormatter = {
            let df = DateFormatter()
            df.timeStyle = .none
            df.dateStyle = .short
            return df
        }()
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            let date = Date(timeIntervalSinceReferenceDate: value)
            let str = df.string(from: date)
            return str
        }
        
    }
    
}
