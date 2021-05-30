import UIKit

class WeightAndRepsTextField: UITextField {
  init() {
    super.init(frame: CGRect.zero)
    textAlignment = .center
    inputView = Keyboard.shared

    setFontScaling(minimum: 6)
  }

  override var placeholder: String? {
    didSet {
      guard let ph = placeholder else { return }
      let attributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
      attributedPlaceholder = NSAttributedString(
        string: ph, attributes: attributes)
    }
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }

  func setNumber(double: Double) {
    if double.remainder(dividingBy: 1) == 0 {
      setNumber(int: Int(double))
    } else {
      setNumberString("\(double)")
    }
  }

  func setNumber(int: Int) {
    setNumberString("\(int)")
  }

  private func setNumberString(_ string: String) {
    text = string
  }
}
