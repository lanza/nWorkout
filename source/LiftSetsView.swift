import SwiftUI

struct HDivider: View {
  let color: Color = .black
  let width: CGFloat = 1.6
  var body: some View {
    Rectangle()
      .fill(color)
      .frame(height: width)
      .edgesIgnoringSafeArea(.horizontal)
  }
}

struct VDivider: View {
  let color: Color = .black
  let width: CGFloat = 2
  var body: some View {
    Rectangle()
      .fill(color)
      .frame(width: 2, height: 15)
      .edgesIgnoringSafeArea(.vertical)
  }
}

struct LiftSetsView: View {
  let sets: [NSet]
  init(sets: [NSet], frameHeightMultiplier: Int = 60) {
    self.sets = sets
    self.frameHeightMultiplier = frameHeightMultiplier
  }

  let frameHeightMultiplier: Int

  var body: some View {
    LazyVStack(alignment: .center, spacing: 0) {
      HDivider()
      HStack(
        alignment: .center,
        content: {
          Text("Target")
            .frame(
              minWidth: 0, maxWidth: .infinity, minHeight: 0,
              maxHeight: .infinity
            )
            .multilineTextAlignment(.center)
            .font(.system(size: 12))
          Spacer()
          Text("Completed")
            .frame(
              minWidth: 0, maxWidth: .infinity, minHeight: 0,
              maxHeight: .infinity
            )
            .multilineTextAlignment(.center)
            .font(.system(size: 12))
          Spacer()
        }
      )
      .padding(EdgeInsets(top: 7, leading: 20, bottom: 4, trailing: 20))
      HStack(
        alignment: .center,
        content: {
          Spacer()
          Text("Weight")
            .frame(
              minWidth: 0, maxWidth: .infinity, minHeight: 0,
              maxHeight: .infinity
            )
            .multilineTextAlignment(.center)
            .font(.system(size: 12))
          Spacer()
          Text("Reps")
            .frame(
              minWidth: 0, maxWidth: .infinity, minHeight: 0,
              maxHeight: .infinity
            )
            .multilineTextAlignment(.center)
            .font(.system(size: 12))
          Spacer()
          Text("Weight")
            .frame(
              minWidth: 0, maxWidth: .infinity, minHeight: 0,
              maxHeight: .infinity
            )
            .multilineTextAlignment(.center)
            .font(.system(size: 12))
          Spacer()
          Text("Reps")
            .frame(
              minWidth: 0, maxWidth: .infinity, minHeight: 0,
              maxHeight: .infinity
            )
            .multilineTextAlignment(.center)
            .font(.system(size: 12))
          Spacer()
        }
      )
      .padding(EdgeInsets(top: 4, leading: 20, bottom: 7, trailing: 20))
      HDivider()
      ForEach(
        sets,
        content: { (set: NSet) in
          HStack(
            alignment: .center,
            content: {
              Spacer()
              HStack(alignment: .center) {
                Text(String(set.weight))
                  .frame(
                    minWidth: 0, maxWidth: .infinity, minHeight: 0,
                    maxHeight: .infinity)
                Spacer()
                Text(String(set.reps))
                  .frame(
                    minWidth: 0, maxWidth: .infinity, minHeight: 0,
                    maxHeight: .infinity)
                Spacer()
                Text(String(set.completedWeight))
                  .frame(
                    minWidth: 0, maxWidth: .infinity, minHeight: 0,
                    maxHeight: .infinity)
                Spacer()
                Text(String(set.completedReps))
                  .frame(
                    minWidth: 0, maxWidth: .infinity, minHeight: 0,
                    maxHeight: .infinity)
              }
              .padding(
                EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
              Spacer()
            })
          HDivider()
        })
    }
    //    .frame(height: CGFloat(sets.count * frameHeightMultiplier))
  }
}

struct LiftSetsView_Previews: PreviewProvider {
  static var previews: some View {
    let w = NWorkout.new(name: "Muffin")
    let l1 = NLift.makeDummy(workout: w)
    _ = NSet.makeDummy(lift: l1)
    _ = NSet.makeDummy(lift: l1)
    return LiftSetsView(sets: l1.getOrderedSets())
  }
}
