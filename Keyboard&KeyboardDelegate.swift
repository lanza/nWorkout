import UIKit

protocol KeyboardDelegate: class {
  func keyWasTapped(character: String)
  func hideWasTapped()
  func backspaceWasTapped()
  func nextWasTapped()
}

class Keyboard: UIView {
  static let shared: Keyboard = Keyboard(
    frame: CGRect(
      x: 0,
      y: 0,
      width: 1,
      height: Double(
        (UIApplication.shared.windows.first?.rootViewController?.view.frame
          .size.height)!
      )
        * Lets
        .keyboardToViewRatio
    )
  )

  weak var delegate: KeyboardDelegate?

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    createStacks()
    bindActions()
    backgroundColor = Theme.Colors.Keyboard.background
    let buttons = [
      zeroButton, buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive,
      buttonSix, buttonSeven,
      buttonEight, buttonNine, thirdSideButton, topSideButton, secondSideButton,
      decimalButton,
      backspaceButton, nextButton,
    ]
    for button in buttons {
      button.titleLabel?.tintColor = Theme.Colors.Keyboard.keys
    }
  }

  init() {
    super.init(frame: CGRect())
    createStacks()
    bindActions()
    backgroundColor = Theme.Colors.Keyboard.background
    let buttons = [
      zeroButton, buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive,
      buttonSix, buttonSeven,
      buttonEight, buttonNine, thirdSideButton, topSideButton, secondSideButton,
      decimalButton,
      backspaceButton, nextButton,
    ]
    for button in buttons {
      button.titleLabel?.tintColor = Theme.Colors.Keyboard.keys
    }
  }

  let buttonOne = UIButton()
  let buttonTwo = UIButton()
  let buttonThree = UIButton()
  let topSideButton = UIButton()
  let buttonFour = UIButton()
  let buttonFive = UIButton()
  let buttonSix = UIButton()
  let secondSideButton = UIButton()
  let buttonSeven = UIButton()
  let buttonEight = UIButton()
  let buttonNine = UIButton()
  let thirdSideButton = UIButton()
  let decimalButton = UIButton()
  let zeroButton = UIButton()
  let backspaceButton = UIButton()
  let nextButton = UIButton()
  let hideButton = UIButton()

  func bindActions() {

    let numberButtons = [
      zeroButton, buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive,
      buttonSix, buttonSeven,
      buttonEight, buttonNine, decimalButton,
    ]
    var characters = (0...9).map { "\($0)" }
    characters.append(".")

    for (number, button) in zip(characters, numberButtons) {
      button.setTitle(String(number), for: UIControl.State())
      button.addTarget(
        self,
        action: #selector(keyTapped(_:)),
        for: .touchUpInside
      )
    }

    backspaceButton.setTitle("←", for: .normal)
    backspaceButton.addTarget(
      self,
      action: #selector(backspaceTapped(_:)),
      for: .touchUpInside
    )

    nextButton.setTitle("Next", for: UIControl.State())
    nextButton.addTarget(
      self,
      action: #selector(nextTapped(_:)),
      for: .touchUpInside
    )
  }

  func createStacks() {
    let firstStackView = UIStackView(
      arrangedSubviews: [buttonOne, buttonTwo, buttonThree, topSideButton])
    let secondStackView = UIStackView(
      arrangedSubviews: [buttonFour, buttonFive, buttonSix, secondSideButton])
    let thirdStackView = UIStackView(
      arrangedSubviews: [buttonSeven, buttonEight, buttonNine, thirdSideButton])
    let fourthStackView = UIStackView(
      arrangedSubviews: [
        decimalButton, zeroButton, backspaceButton, nextButton,
      ]
    )

    let stackViews = [
      firstStackView, secondStackView, thirdStackView, fourthStackView,
    ]

    for stackView in stackViews {
      stackView.axis = .horizontal
      stackView.distribution = .fillEqually
      stackView.alignment = .center
      stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    let masterStackView = UIStackView(arrangedSubviews: stackViews)
    masterStackView.axis = .vertical
    masterStackView.distribution = .fillEqually
    masterStackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(masterStackView)

    hideButton.setTitle("Hide", for: UIControl.State())

    hideButton.translatesAutoresizingMaskIntoConstraints = false
    addSubview(hideButton)
    hideButton.addTarget(
      self,
      action: #selector(hideTapped(_:)),
      for: .touchUpInside
    )

    var constraints: [NSLayoutConstraint] = []
    constraints.append(hideButton.leftAnchor.constraint(equalTo: leftAnchor))
    constraints.append(hideButton.rightAnchor.constraint(equalTo: rightAnchor))
    constraints.append(
      hideButton.bottomAnchor.constraint(equalTo: masterStackView.topAnchor)
    )
    constraints.append(hideButton.topAnchor.constraint(equalTo: topAnchor))

    constraints.append(
      masterStackView.leftAnchor.constraint(equalTo: leftAnchor)
    )
    constraints.append(
      masterStackView.rightAnchor.constraint(equalTo: rightAnchor)
    )
    constraints.append(
      masterStackView.bottomAnchor.constraint(
        equalTo: bottomAnchor, constant: -60)
    )
    NSLayoutConstraint.activate(constraints)
  }

  @IBAction func keyTapped(_ sender: UIButton) {
    delegate?.keyWasTapped(character: sender.titleLabel!.text!)
  }

  @IBAction func hideTapped(_ sender: UIButton) {
    delegate?.hideWasTapped()
  }

  @IBAction func backspaceTapped(_ sender: UIButton) {
    delegate?.backspaceWasTapped()
  }

  @IBAction func nextTapped(_ sender: UIButton) {
    delegate?.nextWasTapped()
  }

}
