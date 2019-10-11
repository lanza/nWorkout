import UIKit

class StartBlankWorkoutButton: UIButton {
  static func create() -> StartBlankWorkoutButton {
    let button = StartBlankWorkoutButton()
    button.setTitle(Lets.startBlankWorkout)

    button.backgroundColor = Theme.Colors.dark
    button.setTitleColor(.white)

    return button
  }
}
