import SwiftUI

struct WorkoutDetailView: View {
  @ObservedObject var workout: NewWorkout
  var body: some View {
    List {
      DatePicker(
        "Start Date", selection: $workout.startDate, in: ...Date(),
        displayedComponents: [.date, .hourAndMinute])
      if workout.finishDate != nil {
        DatePicker(
          "Finish Date", selection: Binding($workout.finishDate)!,
          in: ...Date(), displayedComponents: [.date, .hourAndMinute])
      }
      //      TextEditor(text: $workout.note)
    }
  }
}
