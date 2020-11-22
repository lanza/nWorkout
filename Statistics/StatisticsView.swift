import SwiftUI

let df: DateFormatter = {
  let df = DateFormatter()
  df.dateFormat = "MM-dd-yyyy"
  return df
}()

struct StatisticsView: View {
  @ObservedObject var jdb: JDB

  init(jdb: JDB) {
    self.jdb = jdb
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

    var result: [(elements: [NewLift], name: String, count: Int)] = []
    for key in counts.keys {
      result.append((elements[key, default: []], key, counts[key, default: 0]))
    }
    result.sort { left, right in
      return left.name < right.name
    }
    return result
  }

  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(alignment: .center, spacing: 0, pinnedViews: []) {
          ForEach(getLifts(), id: \.1) { (lifts, name, count) in

            //            GeometryReader { geometry in
            //              Path { path in
            //                path.move(to: .init(x: 0, y: 0))
            //                path.addLine(to: .init(x: geometry.size.width, y: 0))
            //              }
            //              .strokedPath(.init(lineWidth: 1, dash: [1, 2]))
            //            }
            //            .foregroundColor(.red)
            //            .frame(height: 1)

            NavigationLink(
              destination:
                LiftStatisticsView(lifts: lifts, name: name, count: count)
            ) {
              HStack {
                Text(name)
                Spacer()
                Text(String(count))
              }
              .foregroundColor(.white).font(.headline)
            }.padding()

          }
          .border(Color.black)
          .listRowBackground(Color(Theme.Colors.dark))
          .listItemTint(Color(Theme.Colors.dark))
          .navigationBarTitle("Statistics")
        }
        .foregroundColor(Color(Theme.Colors.darker))
        .background(Color(Theme.Colors.dark))
      }
    }
  }
}

struct LiftSetsView: View {
  let lift: NewLift
  var body: some View {
    List {
      ForEach(lift.sets) { set in
        HStack(alignment: .center) {
          Text(String(set.weight))
          Spacer()
          Text(String(set.reps))
          Spacer()
          Text(String(set.completedWeight))
          Spacer()
          Text(String(set.completedReps))
        }
        .listRowBackground(Color(Theme.Colors.dark))
        //          .frame(height: CGFloat(30))
      }
    }
    .frame(height: CGFloat(lift.sets.count * 44))
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
        List {
          ForEach(lifts) { lift in
            VStack {
              Text("\(df.string(from: lift.workout!.startDate))")
              LiftSetsView(lift: lift)
            }
            .listRowBackground(Color(Theme.Colors.dark))
          }
        }
        .foregroundColor(.white).font(.headline)
        .background(Color(Theme.Colors.darkest))
      } else {
        Spacer()
        Text("Charts").bold()
        Text("Not yet implemented.")
        Spacer()
      }
    }
    .navigationBarTitle("\(name) Statistics")
    .background(Color(Theme.Colors.dark))
  }
}

struct Statistics_Previews: PreviewProvider {
  static var previews: some View {
    StatisticsView(jdb: makeFakeJDB())

  }
}

func makeFakeJDB() -> JDB {
  let jdb = JDB()
  jdb.workouts = []
  let w = NewWorkout()
  w.isWorkout = true
  w.name = "Doggie"
  let l1 = NewLift()
  l1.name = "Muffin Petting"
  l1._previousStrings = "IDK"
  l1.isWorkout = true
  l1.note = ""

  let l2 = NewLift()
  l2.name = "Riley Feeding"
  l2._previousStrings = "IDK"
  l2.isWorkout = true
  l2.note = ""

  let s = NewSet()
  s.reps = 5
  s.weight = 55
  s.completedReps = 5
  s.completedWeight = 55
  s.setTarget(weight: 45, reps: 22)
  l1.sets.append(s)
  l2.sets.append(s)
  w.lifts.append(l1)
  w.lifts.append(l2)
  jdb.addWorkout(w)
  return jdb
}
