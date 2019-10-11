import UIKit

class SetNumberLabel: UILabel {
  init() {
    super.init(frame: CGRect.zero)
    textAlignment = .center

    textColor = .white
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}
