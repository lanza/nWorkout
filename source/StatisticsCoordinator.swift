import SwiftUI
import UIKit

class StatisticsCoordinator: Coordinator {
  override func loadViewController() {
    let hostingVC = UIHostingController(
      rootView: StatisticsView(workouts: []))
    viewController = hostingVC
  }
}
