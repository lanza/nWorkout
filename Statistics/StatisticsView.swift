import SwiftUI

struct StatisticsView: View {
  @ObservedObject var jdb = JDB.shared
  
  func getLifts() -> [([NewLift], String, Int)] {
    let filtered = jdb.workouts.filter { $0.isWorkout }
    let lifts = filtered.map { $0.lifts }
    let reduced = lifts.flatMap{$0}
    let sorted = reduced.sorted { $0.name < $1.name }
    
    var counts: [String:Int] = [:]
    var elements: [String:[NewLift]] = [:]
    
    for element in sorted {
      counts[element.name, default: 0] += 1
      elements[element.name, default: []].append(element)
    }
    
    var result: [([NewLift], String, Int)] = []
    for key in counts.keys {
      result.append((elements[key, default: []], key, counts[key, default: 0]))
    }
    return result
  }
  
  let df = DateFormatter()
  var body: some View {
    NavigationView {
      List(getLifts(), id: \.1) { (lifts, name, count) in
        NavigationLink(destination:
        LiftStatisticsView(lifts: lifts, name: name, count: count)) {
          HStack {
            Text(name).foregroundColor(.white).font(.headline)
            Text(String(count)).foregroundColor(.white).font(.headline)
          }
        }
      }.navigationBarTitle("Statistics")
    }
  }
}

struct LiftStatisticsView: View {
  let lifts: [NewLift]
  let name: String
  let count: Int
  var body: some View {
    VStack {
      Text(name)
      Text(String(count))
      List(lifts) { lift in
        Text(String(lift.sets.count))
      }
    }
    .foregroundColor(.white).font(.headline)
    .background(Color(Theme.Colors.darkest))
  }
}

struct Statistics_Previews: PreviewProvider {
  static var previews: some View {
    StatisticsView()
  }
}
