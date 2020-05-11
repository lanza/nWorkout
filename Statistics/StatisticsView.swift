import SwiftUI

struct StatisticsView: View {
  @ObservedObject var jdb = JDB.shared
  
  let df = DateFormatter()
  var body: some View {
    NavigationView {
      List(jdb.workouts.filter { $0.isWorkout }) { workout in
        Text("Workout").foregroundColor(.white).font(.headline)
      }.navigationBarTitle("Statistics")
    }
  }
}

struct Statistics_Previews: PreviewProvider {
  static var previews: some View {
    StatisticsView()
  }
}
