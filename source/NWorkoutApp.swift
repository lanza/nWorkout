import SwiftUI
import UIKit

struct WorkoutTVCHost: UIViewControllerRepresentable {
  @Binding var workout: NWorkout?
  func makeUIViewController(context: Context) -> some UIViewController {
    let workoutTVC = WorkoutTVC()
    workoutTVC.workout = workout
    workoutTVC.cancelWorkout = {
      workout = nil
    }
    workoutTVC.finishWorkout = {
      workout = nil
    }
    return workoutTVC
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

//struct ActiveWorkoutView : View {
//  @Binding var workout: NWorkout
//  var body: some View {
//
//  }
//}
struct InactiveWorkoutView: View {
  @Binding var activeWorkout: NWorkout?

  var body: some View {
    Button(
      "Start Blank Workout",
      action: {
        activeWorkout = NWorkout.new(
          isComplete: false,
          name: Lets.blank
        )
      })
  }
}

struct MainView: View {
  @State var activeWorkout: NWorkout?

  var body: some View {
    TabView {
      NavigationView {
        WorkoutsTVCHost()
          .navigationTitle("Workouts")
      }
      .tabItem { Label("Workouts", image: "workout") }
      WorkoutsView()
        .tabItem { Label("Routines", image: "routine") }
      if activeWorkout != nil {
        WorkoutTVCHost(workout: $activeWorkout)
          .tabItem { Label("Active", systemImage: "list.dash") }
      } else {
        // TODO: make this process animated
        InactiveWorkoutView(activeWorkout: $activeWorkout)
          .tabItem { Label("Inactive", systemImage: "list.dash") }
      }
      StatisticsView(workouts: [])
        .tabItem { Label("Statistics", image: "statistics") }
      NavigationView {
        SettingsTVCHost()
          .navigationTitle("Settings")
      }
      .tabItem { Label("Settings", image: "settings") }
    }
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
