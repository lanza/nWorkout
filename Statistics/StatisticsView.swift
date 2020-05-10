import SwiftUI
import Foundation

struct StatisticsView: View {
  let workouts: [NewWorkout] = JDB.getWorkouts().filter { return $0.isWorkout }
  let df = DateFormatter()
  var body: some View {
    List(workouts) { workout in
      Text("Workout")
    }
  }
}

struct Statistics_Previews: PreviewProvider {
  static var previews: some View {
    StatisticsView()
  }
}
