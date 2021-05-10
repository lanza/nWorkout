import SwiftUI

struct LiftSetsView: View {
  let lift: NLift
  let sets: [NSet]
  init(lift: NLift) {
    self.lift = lift
    self.sets = lift.getOrderedSets()
  }
  var body: some View {
    LazyVStack(alignment: .center, spacing: 0) {
      ForEach(sets) { set in
        HStack(alignment: .center) {
          Spacer()
          HStack(alignment: .center) {
            Text(String(set.weight))
            Spacer()
            Text(String(set.reps))
            Spacer()
            Text(String(set.completedWeight))
            Spacer()
            Text(String(set.completedReps))
          }
          .padding()
          .border(Color.black)
          Spacer()
        }
      }
    }
    .frame(height: CGFloat(lift.sets!.count * 60))
  }
}

struct LiftSetsView_Previews: PreviewProvider {
  static var previews: some View {
    let s1 = NSet.makeDummy()
    let s2 = NSet.makeDummy()
    let l1 = NLift.makeDummy()
    l1.append(s1)
    l1.append(s2)
    return LiftSetsView(lift: l1)
  }
}
