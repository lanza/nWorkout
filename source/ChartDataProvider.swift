import Foundation

struct ChartDataPair {
  let timeInterval: TimeInterval
  let weight: Double
}

final class StatisticsDataProvider {
  let liftName: String
  let lifts: [NLift]

  init(liftName: String) {
    self.liftName = liftName
    self.lifts = [NLift]().filter { $0.getName() == liftName }.sorted {
      $0.workout!.startDate! < $1.workout!.startDate!
    }
  }

  func getBestSetDataPoints() -> [ChartDataPair] {
    let values = lifts.map(generateBestSetDataPair)
    return values
  }

  private func generateBestSetDataPair(from lift: NLift) -> ChartDataPair {
    let timeInterval = lift.workout!.startDate!.timeIntervalSinceReferenceDate
    let set = lift.getSetsSorted().last
    let weight = set?.completedWeight ?? 0
    return ChartDataPair(timeInterval: timeInterval, weight: weight)
  }

  func getPersonalRecordDataPoints() -> [ChartDataPair] {
    var prWeight: Double = 0
    var prTimeInterval: TimeInterval = 0
    var prDataPoints: [ChartDataPair] = []
    for lift in lifts {
      var bestCompletedWeight: Double = 0
      for s in lift.sets! {
        let set = s as! NSet
        if set.completedReps == set.reps {
          if set.completedWeight > bestCompletedWeight {
            bestCompletedWeight = set.completedWeight
          }
        }
      }
      if bestCompletedWeight > prWeight {
        prWeight = bestCompletedWeight
      }
      prTimeInterval = lift.workout!.startDate!.timeIntervalSinceReferenceDate
      prDataPoints.append(
        ChartDataPair(timeInterval: prTimeInterval, weight: prWeight)
      )
    }

    return prDataPoints
  }

  func getPersonalRecordProgression() -> [NSet] {

    var sets: [NSet] = []

    for lift in lifts {

      var setIsNew = true
      var bestCompletedSet: NSet?

      for s in lift.sets! {
        let set = s as! NSet
        if set.completedReps == set.reps,
          let bestCompletedWeight = bestCompletedSet?.completedWeight,
          set.completedWeight > bestCompletedWeight
        {
          bestCompletedSet = set
        }
      }

      if setIsNew, let best = bestCompletedSet {
        sets.append(best)
      }
      setIsNew = false
    }

    return sets
  }

}
