import UIKit

class StatisticsCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: StatisticsCell.reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
}
