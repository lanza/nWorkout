import SwiftUI

struct WorkoutDetailView: View {
  @ObservedObject var workout: NWorkout
  var body: some View {
    LazyVStack {
      DatePicker(
        "Start Date", selection: $workout.startDate, in: ...Date(),
        displayedComponents: [.date, .hourAndMinute]
      )
      .foregroundColor(.white)
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
        .foregroundColor(.white)
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .stroke(Color.black, lineWidth: 2)
        )
      }
      //      TextEditor(text: $workout.note)
    }
    .padding()
    Spacer(minLength: 50)
  }
}

struct WorkoutDetail_Preview: PreviewProvider {
  static var previews: some View {
    let w = NWorkout.makeDummy()
    return WorkoutDetailView(workout: w)
  }
}
