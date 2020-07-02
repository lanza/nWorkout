import SwiftUI
import UIKit

class WorkoutDetailCoordinator: Coordinator {

  let workout: NewWorkout!

  init(workout: NewWorkout) {
    self.workout = workout
    super.init()
  }

  override func loadViewController() {
    let hostingVC = UIHostingController(
      rootView: WorkoutDetailView(workout: workout))
    hostingVC.view.backgroundColor = Theme.Colors.darkest
    viewController = hostingVC
  }
}
