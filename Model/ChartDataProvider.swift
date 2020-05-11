import Foundation

struct ChartDataPair {
  let timeInterval: TimeInterval
  let weight: Double
}

final class StatisticsDataProvider {
  let liftName: String
  let lifts: [NewLift]

  init(liftName: String) {
    self.liftName = liftName
    self.lifts = JDB.shared.getLifts().filter { $0.name == liftName }
      .filter { $0.isWorkout == true }.sorted {
        $0.workout!.startDate < $1.workout!.startDate
      }
  }

  func getBestSetDataPoints() -> [ChartDataPair] {
    let values = lifts.map(generateBestSetDataPair)
    return values
  }

  private func generateBestSetDataPair(from lift: NewLift) -> ChartDataPair {
    let timeInterval = lift.workout!.startDate.timeIntervalSinceReferenceDate
    let weight = lift.sets.last?.completedWeight ?? 0
    return ChartDataPair(timeInterval: timeInterval, weight: weight)
  }

  func getPersonalRecordDataPoints() -> [ChartDataPair] {
    var prWeight: Double = 0
    var prTimeInterval: TimeInterval = 0
    var prDataPoints: [ChartDataPair] = []
    for lift in lifts {
      var bestCompletedWeight: Double = 0
      for set in lift.sets {
        if set.completedReps == set.reps {
          if set.completedWeight > bestCompletedWeight {
            bestCompletedWeight = set.completedWeight
          }
        }
      }
      if bestCompletedWeight > prWeight {
        prWeight = bestCompletedWeight
      }
      prTimeInterval = lift.workout!.startDate.timeIntervalSinceReferenceDate
      prDataPoints.append(
        ChartDataPair(timeInterval: prTimeInterval, weight: prWeight)
      )
    }

    return prDataPoints
  }

  func getPersonalRecordProgression() -> [NewSet] {

    var sets: [NewSet] = []

    for lift in lifts {

      var setIsNew = true
      var bestCompletedSet: NewSet?

      for set in lift.sets {
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
