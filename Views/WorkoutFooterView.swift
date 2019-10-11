import RxCocoa
import RxSwift
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

    view.setupRx()
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

  func setupRx() {
    addLiftButton.rx.tap.subscribe(
      onNext: {
        self.delegate.addLiftTapped()
      }
    ).disposed(by: db)
    finishWorkoutButton?.rx.tap.subscribe(
      onNext: {
        self.delegate.finishWorkoutTapped()
      }
    ).disposed(by: db)
    cancelWorkoutButton?.rx.tap.subscribe(
      onNext: {
        self.delegate.cancelWorkoutTapped()
      }
    ).disposed(by: db)
    workoutDetailButton.rx.tap.subscribe(
      onNext: {
        self.delegate.workoutDetailTapped()
      }
    ).disposed(by: db)
  }

  let db = DisposeBag()
}
