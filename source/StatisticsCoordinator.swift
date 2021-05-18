import SwiftUI
import UIKit

class StatisticsCoordinator: Coordinator {
  override func loadViewController() {
    let hostingVC = UIHostingController(
      rootView: StatisticsView(workouts: []))
    hostingVC.view.backgroundColor = Theme.Colors.darkest
    viewController = hostingVC
  }
}
