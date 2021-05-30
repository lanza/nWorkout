import UIKit

class StartBlankWorkoutButton: UIButton {
  static func create() -> StartBlankWorkoutButton {
    let button = StartBlankWorkoutButton()
    button.setTitle(Lets.startBlankWorkout)

    return button
  }
}
