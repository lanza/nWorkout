import UIKit

class StatisticsCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: StatisticsCell.reuseIdentifier)
        
//        accessoryType = .disclosureIndicator

        contentView.backgroundColor = Theme.Colors.dark
        contentView.setShadow(offsetWidth: 3, offsetHeight: 3, radius: 1, opacity: 0.7, color: .black)
        
        textLabel?.textColor = .white
        detailTextLabel?.backgroundColor = .clear
        detailTextLabel?.textColor = .white
        
//        accessoryView?.backgroundColor = Theme.Colors.dark
//        accessoryView?.tintColor = .white
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
}
