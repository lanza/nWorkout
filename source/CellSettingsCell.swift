import UIKit

protocol CellSettingsCellDelegate: class {
  func switchDidChange(to bool: Bool, for cell: CellSettingsCell)
  func widthDidChange(to value: CGFloat, for cell: CellSettingsCell)
}

class CellSettingsCell: UITableViewCell {

  weak var delegate: CellSettingsCellDelegate!

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = Theme.Colors.Table.background
    contentView.backgroundColor = Theme.Colors.Cell.contentBackground
    contentView.setBorder(color: .black, width: 1, radius: 3)

    let views: [UIView] = [titleLabel, widthTextField, onSwitch]
    views.forEach { view in
      contentView.addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = false
    }

    let constraints = [
      titleLabel.leftAnchor.constraint(
        equalTo: contentView.leftAnchor,
        constant: 16
      ),
      titleLabel.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: 4
      ),
      titleLabel.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -4
      ),
      titleLabel.rightAnchor.constraint(equalTo: widthTextField.leftAnchor),
      widthTextField.centerYAnchor.constraint(
        equalTo: contentView.centerYAnchor
      ),
      widthTextField.rightAnchor.constraint(
        equalTo: onSwitch.leftAnchor,
        constant: -4
      ),
      onSwitch.rightAnchor.constraint(
        equalTo: contentView.rightAnchor,
        constant: -4
      ),
      onSwitch.widthAnchor.constraint(equalTo: widthTextField.widthAnchor),
      onSwitch.heightAnchor.constraint(equalTo: widthTextField.heightAnchor),
      onSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      contentView.heightAnchor.constraint(
        greaterThanOrEqualTo: onSwitch.heightAnchor,
        constant: 8
      ),
    ]

    titleLabel.setContentCompressionResistancePriority(
      UILayoutPriority(rawValue: 100),
      for: .horizontal
    )

    NSLayoutConstraint.activate(constraints)

    widthTextField.keyboardType = .decimalPad

    widthTextField.addTarget(
      self, action: #selector(widthTextFieldTextDidChange), for: .editingChanged
    )
    onSwitch.addTarget(
      self, action: #selector(onSwitchValueChanged), for: .valueChanged)
  }

  @objc func widthTextFieldTextDidChange() {
    guard let value = widthTextField.text else { return }
    let val = value.count == 0 ? "0" : value
    self.delegate.widthDidChange(to: CGFloat(Double(val)!), for: self)
  }

  @objc func onSwitchValueChanged() {
    self.delegate.switchDidChange(to: onSwitch.isOn, for: self)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  let titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.textColor = .white
    titleLabel.backgroundColor = .clear
    titleLabel.numberOfLines = 0
    titleLabel.setFontScaling(minimum: 10)
    return titleLabel
  }()

  let widthTextField: UITextField = {
    let widthTextField = UITextField()
    widthTextField.textColor = .white
    widthTextField.textAlignment = .center
    return widthTextField
  }()

  let onSwitch: UISwitch = {
    let onSwitch = UISwitch()
    onSwitch.tintColor = Theme.Colors.main
    onSwitch.onTintColor = Theme.Colors.main
    return onSwitch
  }()
}
