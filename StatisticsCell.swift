import UIKit

class StatisticsCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: StatisticsCell.reuseIdentifier)
        
//        accessoryType = .disclosureIndicator

        contentView.backgroundColor = Theme.Colors.dark
        textLabel?.textColor = .white
        detailTextLabel?.backgroundColor = .clear
        detailTextLabel?.textColor = .white
        
//        accessoryView?.backgroundColor = Theme.Colors.dark
//        accessoryView?.tintColor = .white
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
}
