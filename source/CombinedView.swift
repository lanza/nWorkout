import UIKit

class CombinedView: UIView {

  init() {
    super.init(frame: CGRect.zero)
    isOpaque = false

    completedWeightTextField.translatesAutoresizingMaskIntoConstraints = false
    completedRepsTextField.translatesAutoresizingMaskIntoConstraints = false
    completeButton.translatesAutoresizingMaskIntoConstraints = false
    addSubview(completedWeightTextField)
    addSubview(completedRepsTextField)
    addSubview(completeButton)

    //        completedWeightTextField.setBorder(color: .gray, width: 0.8, radius: 0)
    //        completedRepsTextField.setBorder(color: .gray, width: 0.8, radius: 0)

    NSLayoutConstraint.activate(
      [
        completeButton.leftAnchor.constraint(equalTo: leftAnchor),
        completeButton.rightAnchor.constraint(equalTo: rightAnchor),
        completeButton.topAnchor.constraint(equalTo: topAnchor),
        completeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
      ]
    )
  }

  let completedWeightTextField = CompletedWeightAndRepsTextField()
  let completedRepsTextField = CompletedWeightAndRepsTextField()
  let completeButton = CompleteButton()

  override func layoutSubviews() {
    super.layoutSubviews()

    completeButton.frame = CGRect(
      x: 0,
      y: 0,
      width: frame.width,
      height: frame.height
    )
    completedWeightTextField.frame = CGRect(
      x: 0,
      y: 0,
      width: (frame.width / 2) - 1,
      height: frame.height
    )
    completedRepsTextField.frame = CGRect(
      x: (frame.width / 2) + 1,
      y: 0,
      width: (frame.width / 2) - 1,
      height: frame.height
    )

  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}
