import SwiftUI

struct WorkoutOverviewView: View {
  let workout: NWorkout
  var body: some View {
    Text("Lift count: \(workout.getLiftsSorted().count)")
  }
}

struct WorkoutsView: View {
  let workouts: [NWorkout]
  var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          ForEach(
            workouts,
            content: { workout in
              NavigationLink(
                destination: WorkoutView(workout: workout),
                label: {
                  WorkoutOverviewView(workout: workout)
                    .padding(.all, 10)
                })
            }
          )
          .navigationTitle("Routines")
        }
      }
    }
  }
}

struct WorkoutsView_Previews: PreviewProvider {
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
    WorkoutsView(workouts: [getWorkout(), getWorkout()])
  }
}
