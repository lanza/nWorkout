import SwiftUI

let df: DateFormatter = {
  let df = DateFormatter()
  df.dateFormat = "MM-dd-yyyy"
  return df
}()

struct StatisticsView: View {
  @ObservedObject var jdb = JDB.shared

  init(jdb: JDB) {
    let app = UINavigationBarAppearance()
    app.backgroundColor = Theme.Colors.darkest
    app.largeTitleTextAttributes = [
      NSAttributedString.Key.foregroundColor: Theme.Colors.Nav.title
    ]
    app.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: Theme.Colors.Nav.title
    ]

    UINavigationBar.appearance().standardAppearance = app
    UINavigationBar.appearance().scrollEdgeAppearance = app
    UINavigationBar.appearance().prefersLargeTitles = true
  }

  func getLifts() -> [([NewLift], String, Int)] {
    let filtered = jdb.workouts.filter { $0.isWorkout }
    let lifts = filtered.map { $0.lifts }
    let reduced = lifts.flatMap { $0 }
    let sorted = reduced.sorted { $0.name < $1.name }

    var counts: [String: Int] = [:]
    var elements: [String: [NewLift]] = [:]

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

  var body: some View {
    NavigationView {
      List(getLifts(), id: \.1) { (lifts, name, count) in
        NavigationLink(
          destination:
            LiftStatisticsView(lifts: lifts, name: name, count: count)
        ) {
          HStack {
            Text(name)
            Text(String(count))
          }.foregroundColor(.white).font(.headline)
        }
      }.navigationBarTitle("Statistics")
    }.background(Color(Theme.Colors.darkest))
  }
}

struct LiftSetsView: View {
  let lift: NewLift
  var body: some View {
    List(lift.sets) { set in
      HStack(alignment: .center) {
        Text(String(set.weight))
        Spacer()
        Text(String(set.reps))
        Spacer()
        Text(String(set.completedWeight))
        Spacer()
        Text(String(set.completedReps))
      }
    }.frame(height: CGFloat(lift.sets.count * 50))
  }
}

struct LiftStatisticsView: View {
  let lifts: [NewLift]
  let name: String
  let count: Int

  @State var historyOrChartsToggle = 0

  init(lifts: [NewLift], name: String, count: Int) {
    self.lifts = lifts
    self.name = name
    self.count = count

  }

  var body: some View {
    VStack {
      Picker(selection: $historyOrChartsToggle, label: Text("IDK")) {
        Text("History").tag(0)
        Text("Charts").tag(1)
      }
      .pickerStyle(SegmentedPickerStyle())
      .foregroundColor(.white).font(.headline)
      .background(Color(Theme.Colors.darkest))

      if historyOrChartsToggle == 0 {
        List(lifts) { lift in
          VStack {
            Text("\(df.string(from: lift.workout!.startDate))")
            LiftSetsView(lift: lift)
          }
        }
        .foregroundColor(.white).font(.headline)
        .background(Color(Theme.Colors.darkest))
      } else {
        Spacer()
        Text("Charts")
        Spacer()
      }
    }
    .navigationBarTitle("\(name) Statistics")
    .background(Color(Theme.Colors.darkest))
  }
}

struct Statistics_Previews: PreviewProvider {
  static var previews: some View {
    StatisticsView(jdb: makeFakeJDB())
  }
}

func makeFakeJDB() -> JDB {
  let jdb = JDB()
  let w = NewWorkout()
  let l = NewLift()
  let s = NewSet()
  s.completedReps = 5
  s.completedWeight = 55
  s.setTarget(weight: 45, reps: 22)
  l.sets.append(s)
  w.lifts.append(l)
  jdb.addWorkout(w)
  return jdb
}
