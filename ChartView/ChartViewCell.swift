import UIKit

open class ChartViewCell: UITableViewCell {
    
    public let topContentView = UIView()
    public let chartView = ChartView()
    public let bottomContentView = UIView()
    
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        topContentView.translatesAutoresizingMaskIntoConstraints = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
        bottomContentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(topContentView)
        contentView.addSubview(chartView)
        contentView.addSubview(bottomContentView)
        
        let cvba = chartView.bottomAnchor.constraint(equalTo: bottomContentView.topAnchor)
        cvba.priority = cvba.priority - 10
        
        NSLayoutConstraint.activate([
            topContentView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 4),
            topContentView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: -6),
            topContentView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor, constant: 6),
            topContentView.bottomAnchor.constraint(equalTo: chartView.topAnchor),
            chartView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: -6),
            chartView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor, constant: 6),
            cvba,
            bottomContentView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: -6),
            bottomContentView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor, constant: 6),
            bottomContentView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -4)
        ])
        selectionStyle = .none
    }
    public required init?(coder aDecoder: NSCoder) { fatalError() }
}
