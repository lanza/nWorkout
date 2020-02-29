import UIKit

protocol WorkoutFooterViewDelegate: class {
  func addLiftTapped()
  func cancelWorkoutTapped()
  func finishWorkoutTapped()
  func workoutDetailTapped()
}

class WorkoutFooterView: UIView {

  weak var delegate: WorkoutFooterViewDelegate!

  var activeOrFinished: ActiveOrFinished!

  let addLiftButton = WorkoutFooterViewButton.create(
    title: Lets.addLift,
    type: .addLift
  )

  var cancelWorkoutButton: WorkoutFooterViewButton!
  var finishWorkoutButton: WorkoutFooterViewButton!

  var workoutDetailButton = WorkoutFooterViewButton.create(
    title: Lets.viewWorkoutDetails,
    type: .details
  )

  let buttonHeight: CGFloat = 34
  let betweenButtonSpacing: CGFloat = 4
  let margins: CGFloat = 8

  static func create(_ activeOrFinished: ActiveOrFinished) -> WorkoutFooterView
  {

    let buttonHeight: CGFloat = 34
    let betweenButtonSpacing: CGFloat = 4
    let margins: CGFloat = 8

    let buttonCount: CGFloat = activeOrFinished == .active ? 4 : 2

    let height = (buttonHeight * buttonCount) + (
      betweenButtonSpacing * (buttonCount - 1)
    ) + (
      margins * 2
    )

    let view = WorkoutFooterView(
      frame: CGRect(x: 0, y: 0, width: 0, height: height)
    )

    view.activeOrFinished = activeOrFinished

    var buttons: [WorkoutFooterViewButton] = [view.addLiftButton]

    if view.activeOrFinished == .active {
      view.cancelWorkoutButton = WorkoutFooterViewButton.create(
        title: Lets.cancelWorkout,
        type: .cancel
      )
      view.finishWorkoutButton = WorkoutFooterViewButton.create(
        title: Lets.finishWorkout,
        type: .finish
      )
      buttons.append(
        contentsOf: [view.cancelWorkoutButton, view.finishWorkoutButton]
      )
    }

    buttons.append(view.workoutDetailButton)

    for button in buttons {
      view.addSubview(button)
    }
    
    view.setupActions()
    return view
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let width = frame.width - (2 * margins)

    if activeOrFinished == .active {
      addLiftButton.frame = CGRect(
        x: margins,
        y: margins,
        width: width,
        height: buttonHeight
      )
      cancelWorkoutButton.frame = CGRect(
        x: margins,
        y: margins + (1 * buttonHeight) + (1 * betweenButtonSpacing),
        width: width,
        height: buttonHeight
      )
      finishWorkoutButton.frame = CGRect(
        x: margins,
        y: margins + (2 * buttonHeight) + (2 * betweenButtonSpacing),
        width: width,
        height: buttonHeight
      )
      workoutDetailButton.frame = CGRect(
        x: margins,
        y: margins + (3 * buttonHeight) + (3 * betweenButtonSpacing),
        width: width,
        height: buttonHeight
      )
    }
    else {
      addLiftButton.frame = CGRect(
        x: margins,
        y: margins,
        width: width,
        height: buttonHeight
      )
      workoutDetailButton.frame = CGRect(
        x: margins,
        y: margins + (1 * buttonHeight) + (1 * betweenButtonSpacing),
        width: width,
        height: buttonHeight
      )
    }
  }
  
  @objc func addLiftButtonTapped() { self.delegate.addLiftTapped() }
  @objc func finishWorkoutButtonTapped() { self.delegate.finishWorkoutTapped() }
  @objc func cancelWorkoutButtonTapped() { self.delegate.cancelWorkoutTapped() }
  @objc func workoutDetailButtonTapped() { self.delegate.workoutDetailTapped() }

  func setupActions() {
    addLiftButton.addTarget(self, action: #selector(addLiftButtonTapped), for: .touchUpInside)
    finishWorkoutButton?.addTarget(self, action: #selector(finishWorkoutButtonTapped), for: .touchUpInside)
    cancelWorkoutButton?.addTarget(self, action: #selector(cancelWorkoutButtonTapped), for: .touchUpInside)
    workoutDetailButton.addTarget(self, action: #selector(workoutDetailButtonTapped), for: .touchUpInside)
  }
}
