import UIKit

class SettingsCell: UITableViewCell {
  weak var nameLabel: UILabel!
  weak var widthTextField: UITextField!
  weak var isOnSwitch: UISwitch!
}

extension SettingsCell: ConfigurableCell {
  func configure(for object: ViewInfo, at indexPath: IndexPath) {}
}
