import SwiftUI

let df: DateFormatter = {
  let df = DateFormatter()
  df.dateFormat = "MM-dd-yyyy"
  return df
}()

struct StatisticsView: View {
  var workouts: [NWorkout]

  init(workouts: [NWorkout]) {
    let request = NWorkout.getFetchRequest()
    request.sortDescriptors = [
      NSSortDescriptor(key: "startDate", ascending: false)
    ]
    self.workouts = try! coreDataStack.getContext().fetch(
      request)
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
    let lifts = workouts.map { $0.lifts!.map { return $0 as! NLift } }
    let reduced = lifts.flatMap { $0 }
    let sorted = reduced.sorted { $0.getName() < $1.getName() }

    var counts: [String: Int] = [:]
    var elements: [String: [NLift]] = [:]

    for element in sorted {
      counts[element.getName(), default: 0] += 1
      elements[element.getName(), default: []].append(element)
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
              .foregroundColor(.white)
              .font(.headline)
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
    StatisticsView(workouts: makeFakeWorkouts())
  }
}

func makeFakeWorkouts() -> [NWorkout] {
  var workouts: [NWorkout] = []

  let w = NWorkout.makeDummy()
  let l1 = NLift.makeDummy(workout: w, name: "Muffin Petting")
  let _ = NSet.makeDummy(lift: l1)
  let l2 = NLift.makeDummy(workout: w, name: "Riley Feeding")
  let _ = NSet.makeDummy(lift: l2)

  w.append(l1)
  w.append(l2)
  workouts.append(w)
  return workouts
}
