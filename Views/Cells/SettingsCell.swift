import UIKit

class SettingsCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var widthTextField: UITextField!
  @IBOutlet weak var isOnSwitch: UISwitch!
}

extension SettingsCell: ConfigurableCell {
  func configure(for object: ViewInfo, at indexPath: IndexPath) {
    //
  }
}
