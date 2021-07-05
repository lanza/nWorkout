import SwiftUI

struct WorkoutOverviewView: View {
  let workout: NWorkout
  var body: some View {
    Text("Lift count: \(workout.getLiftsSorted().count)")
  }
}

struct WorkoutsView: View {
  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    sortDescriptors: [
      NSSortDescriptor(keyPath: \NWorkout.startDate, ascending: true)
    ],
    animation: .default)
  private var workouts: FetchedResults<NWorkout>

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
                }
              )
            }
          )
        }
        .navigationTitle("Routines")
        .padding(15)

      }
    }
  }
}

struct WorkoutsView_Previews: PreviewProvider {
  static var previews: some View {
    WorkoutsView().environment(
      \.managedObjectContext, CoreDataStack.preview.container.viewContext)
  }
}
