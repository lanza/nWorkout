import SwiftUI
import UIKit

class WorkoutDetailCoordinator: Coordinator {

  let workout: NWorkout!

  init(workout: NWorkout) {
    self.workout = workout
    super.init()
  }

  override func loadViewController() {
    let hostingVC = UIHostingController(
      rootView: WorkoutDetailView(workout: workout))
    viewController = hostingVC
  }
}
