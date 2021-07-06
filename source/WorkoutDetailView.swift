import SwiftUI

struct WorkoutDetailView: View {
  @ObservedObject var workout: NWorkout
  var dismiss: (() -> Void)
  var body: some View {
    LazyVStack {
      DatePicker(
        "Start Date", selection: Binding($workout.startDate)!, in: ...Date(),
        displayedComponents: [.date, .hourAndMinute]
      )
      .padding()
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          .stroke(Color.black, lineWidth: 2)
      )
      if workout.finishDate != nil {
        DatePicker(
          "Finish Date", selection: Binding($workout.finishDate)!,
          in: ...Date(), displayedComponents: [.date, .hourAndMinute]
        )
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color.black, lineWidth: 2)
        )
      }
      //      TextEditor(text: $workout.note)
    }
    .padding()
    Spacer(minLength: 50)
    Button(
      "Done",
      action: {
        self.dismiss()
      })
  }
}

struct WorkoutDetail_Preview: PreviewProvider {
  static var previews: some View {
    let w = NWorkout.makeDummy()
    return WorkoutDetailView(workout: w, dismiss: {})
  }
}
