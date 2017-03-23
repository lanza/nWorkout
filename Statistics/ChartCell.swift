import UIKit
import Charts

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
