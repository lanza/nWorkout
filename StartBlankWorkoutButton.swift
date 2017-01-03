import UIKit

class StartBlankWorkoutButton: UIButton {
    static func create() -> StartBlankWorkoutButton {
        let button = StartBlankWorkoutButton()
        button.setTitle("Start Blank Workout")
        return button
    }
}
