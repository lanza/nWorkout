import SwiftUI

struct LiftSetsView: View {
  let lift: NLift
  var body: some View {
    List {
      ForEach(lift.sets) { set in
        HStack(alignment: .center) {
          Text(String(set.weight))
          Spacer()
          Text(String(set.reps))
          Spacer()
          Text(String(set.completedWeight))
          Spacer()
          Text(String(set.completedReps))
        }
        .listRowBackground(Color(Theme.Colors.dark))
        //          .frame(height: CGFloat(30))
      }
    }
    .frame(height: CGFloat(lift.sets.count * 44))
  }
}

