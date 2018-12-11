import UIKit
import Charts

class ChartCell: UITableViewCell {
    
    let chartView = LineChartView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
        setupChartView()
        
        backgroundColor = Theme.Colors.Table.background
        contentView.backgroundColor = Theme.Colors.Cell.contentBackground
        contentView.setBorder(color: .black, width: 1, radius: 3)
        
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func setupConstraints() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: 8),
            chartView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor, constant: -8),
            chartView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -8),
            chartView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 8),
            contentView.heightAnchor.constraint(equalToConstant: 300)
            ])
    }
    
    func setupChartView() {
        chartView.xAxis.valueFormatter = xAxisFormatter
        chartView.xAxis.granularity = 3
        chartView.chartDescription?.text = nil
        
        chartView.backgroundColor = .white
        chartView.setBorder(color: Theme.Colors.darkest, width: 1, radius: 10)
        chartView.layer.masksToBounds = true
    }
    
    let xAxisFormatter = XAxisFormatter()
    
    class XAxisFormatter: NSObject, IAxisValueFormatter {
        
        let df: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "MMM d"
            return df
        }()
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            let date = Date(timeIntervalSinceReferenceDate: value)
            let str = df.string(from: date)
            return str
        }
        
    }
    
}

extension ChartCell: ChartViewDelegate {
    
}
