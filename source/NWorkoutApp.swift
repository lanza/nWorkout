import SwiftUI
import UIKit

struct WorkoutsTVCView: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> some UIViewController {
    let workoutsTVC = WorkoutsTVC()
    return workoutsTVC
  }
  func updateUIViewController(
    _ uiViewController: UIViewControllerType, context: Context
  ) {
  }
}
struct WorkoutsTVCHost: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> some UIViewController {
    let workoutsTVC = WorkoutsTVC()
    return workoutsTVC
  }
  func updateUIViewController(
    _ uiViewController: UIViewControllerType, context: Context
  ) {
  }
}
struct SettingsTVCHost: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> some UIViewController {
    let settingsTVC = SettingsTVC()
    return settingsTVC
  }
  func updateUIViewController(
    _ uiViewController: UIViewControllerType, context: Context
  ) {
  }
}

struct MainView: View {
  var body: some View {
    TabView {
      NavigationView {
        WorkoutsTVCHost()
          .navigationTitle("Workouts")
      }
      .tabItem { Label("Workouts", image: "workout") }
      WorkoutsView()
        .tabItem { Label("Routines", image: "routine") }
      Text("HI")
        .tabItem { Label("Workouts", systemImage: "list.dash") }
      StatisticsView(workouts: [])
        .tabItem { Label("Statistics", image: "statistics") }
      NavigationView {
        SettingsTVCHost()
          .navigationTitle("Settings")
      }
      .tabItem { Label("Settings", image: "settings") }
    }
    //    .background(Color(Theme.Colors.darkest))
  }
}

@main
struct NWorkoutApp: App {
  var body: some Scene {
    WindowGroup {
      MainView().environment(
        \.managedObjectContext, coreDataStack.container.viewContext)
    }
  }
}
