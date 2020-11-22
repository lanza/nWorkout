import SwiftUI

struct LiftStatisticsView: View {
  let lifts: [NLift]
  let name: String
  let count: Int

  @State var historyOrChartsToggle = 0

  init(lifts: [NLift], name: String, count: Int) {
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

func makeFakeData() -> (workout: NWorkout, lifts: [NLift], name: String, count: Int) {
  let l1 = NLift.makeDummy(name: "Pet Muffin")
  let l2 = NLift.makeDummy(name: "Pet Muffin")
  let s1 = NSet.makeDummy()
  let s2 = NSet.makeDummy()
  l1.append(s1)
  l2.append(s2)
  let w = NWorkout.makeDummy()
  w.append(l1)
  w.append(l2)
  return (workout: w, lifts: [l1, l2], name: "Pet Muffin", count: 2)
}

struct LiftStatistics_Previews: PreviewProvider {
  static var w: NWorkout? = nil
  static var previews: some View {
    let data = makeFakeData()
    LiftStatistics_Previews.w = data.workout
    return LiftStatisticsView(lifts: data.lifts, name: data.name, count: data.count)
  }
}
