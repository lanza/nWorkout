import UIKit
import RxSwift

class SettingsCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var isOnSwitch: UISwitch!
    
    var db: DisposeBag!
}

extension SettingsCell: ConfigurableCell {
    func configure(for object: ViewInfo, at indexPath: IndexPath) {
        //
    }
}
