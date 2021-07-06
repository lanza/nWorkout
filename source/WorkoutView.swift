import SwiftUI

extension Int: Identifiable {
  public var id: Int { return self }
}

struct LiftView: View {
  let lift: NLift
  var body: some View {
    VStack {
      HStack {
        Text(lift.getName())
          .font(.title3)
          .padding(10)
        Spacer()
        Button("Note") {}
      }
      ForEach(
        lift.getSetsSorted(),
        content: { nset in
        SetView(nset: nset)
      })
    }
    .padding(10)
  }
}

struct WorkoutView: View {
  @Binding let workout: NWorkout
  var body: some View {
    ScrollView {
      VStack {
        HStack {
          Button("hide") { print("hide") }
          .padding(10)
          Spacer()
          Button("edit") { print("hide") }
          .padding( /*@START_MENU_TOKEN@*/10 /*@END_MENU_TOKEN@*/)
        }
        HStack {
          Text("10:45 PM May 29, 2021")
            .multilineTextAlignment(.leading)
            .font(.title2)
            .padding(10)
          Spacer()
        }
        Divider()
        ForEach(
          workout.getLiftsSorted(),
          content: { lift in
          LiftView(lift: lift)
        })
        Button("Add Lift") {}
        .padding(5)
        if !workout.isComplete {
          Button("Cancel Workout") {}
          .padding(5)
          Button("Finish Workout") {}
          .padding(5)
        }
        Button("View Workout Details") {}
        .padding(5)
      }
    }
  }
}

struct WorkoutViewPreview: PreviewProvider {
  static func getWorkout() -> NWorkout {
    let w = NWorkout.makeDummy(name: "Saturday")
    let l = NLift.makeDummy(workout: w, name: "Squat")
    _ = NSet.makeDummy(lift: l)
    _ = NSet.makeDummy(lift: l)
    _ = NSet.makeDummy(lift: l)
    let k = NLift.makeDummy(workout: w, name: "Bench Press")
    _ = NSet.makeDummy(lift: k)
    _ = NSet.makeDummy(lift: k)
    _ = NSet.makeDummy(lift: k)
    return w
  }
  
  static var previews: some View {
    WorkoutView(workout: getWorkout())
  }
}

struct SetView: View {
  let nset: NSet
  var body: some View {
    HStack {
      Text("Last Workout")
      Spacer()
      Text(String(nset.weight))
      Spacer()
      Text(String(nset.reps))
      Spacer()
      Text(String(nset.completedWeight))
      Spacer()
      Text(String(nset.completedReps))
    }
    .padding(Edge.Set.horizontal, 20)
    .padding(.vertical, 10)
  }
}
