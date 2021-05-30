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
    VStack(alignment: .center, spacing: 0) {
      HStack {
        Picker(selection: $historyOrChartsToggle, label: Text("IDK")) {
          Text("History").tag(0)
          Text("Charts").tag(1)
        }
        .padding()
      }
      .pickerStyle(SegmentedPickerStyle())

      if historyOrChartsToggle == 0 {
        ScrollView {
          LazyVStack(alignment: .center, spacing: 0) {
            ForEach(lifts) { lift in
              VStack(
                alignment: .center,
                spacing: 0
              ) {
                LazyHStack {
                  Text("\(df.string(from: lift.workout!.startDate!))")
                    .font(.title2)
                }
                .padding()
                .background(Color(Theme.Colors.dark))
                LiftSetsView(sets: lift.getOrderedSets())
              }
              .background(Color(Theme.Colors.dark))
              .border(Color.black)
              .listRowBackground(Color(Theme.Colors.dark))
            }
            .foregroundColor(.white).font(.headline)
          }
        }
        .lineSpacing(0)
      } else {
        Spacer()
        Text("Charts").bold()
        Text("Not yet implemented.")
        Spacer()
      }
    }
    .lineSpacing(0)
    .navigationBarTitle("\(name) Statistics")
    .background(Color(Theme.Colors.dark))
  }
}

func makeFakeData() -> (
  workout: NWorkout, lifts: [NLift], name: String, count: Int
) {
  let w = NWorkout.makeDummy()
  let l1 = NLift.makeDummy(workout: w, name: "Pet Muffin")
  _ = NSet.makeDummy(lift: l1)
  _ = NSet.makeDummy(lift: l1)

  let l2 = NLift.makeDummy(workout: w, name: "Pet Muffin")
  _ = NSet.makeDummy(lift: l2)
  _ = NSet.makeDummy(lift: l2)

  w.append(l1)
  w.append(l2)

  return (workout: w, lifts: [l1, l2], name: "Pet Muffin", count: 2)
}

struct LiftStatistics_Previews: PreviewProvider {
  static var w: NWorkout? = nil
  static var previews: some View {
    let data = makeFakeData()
    LiftStatistics_Previews.w = data.workout
    return LiftStatisticsView(
      lifts: data.lifts, name: data.name, count: data.count
    )
  }
}
