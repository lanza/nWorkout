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

  func getLifts() -> [([NLift], String, Int)] {
    let filtered = jdb.workouts.filter { $0.isWorkout }
    let lifts = filtered.map { $0.lifts }
    let reduced = lifts.flatMap { $0 }
    let sorted = reduced.sorted { $0.name < $1.name }

    var counts: [String: Int] = [:]
    var elements: [String: [NLift]] = [:]

    for element in sorted {
      counts[element.name, default: 0] += 1
      elements[element.name, default: []].append(element)
    }

    var result: [(elements: [NLift], name: String, count: Int)] = []
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
      .background(Color(Theme.Colors.darkest))
    }
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

  let w = NWorkout.makeDummy()
  let l1 = NLift.makeDummy(name: "Muffin Petting")
  let l2 = NLift.makeDummy(name: "Riley Feeding")
  let s = NSet.makeDummy()
  l1.append(s)
  l2.append(s)

  w.append(l1)
  w.append(l2)
  jdb.addWorkout(w)
  return jdb
}
