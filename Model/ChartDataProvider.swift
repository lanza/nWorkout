import Foundation
import RealmSwift

struct ChartDataPair {
    let timeInterval: TimeInterval
    let weight: Double
}


final class ChartDataProvider {
    let liftName: String
    let lifts: [Lift]
    init(liftName: String) {
        self.liftName = liftName
        self.lifts = RLM.objects(type: Lift.self).filter { $0.name == liftName }.sorted { $0.workout!.startDate < $1.workout!.startDate }
    }
    
//    private func getRealmObjects() -> [Lift] {
//        return RLM.objects(type: Lift.self).filter { $0.name == self.liftName }.sorted { $0.workout!.startDate < $1.workout!.startDate }
//    }
    
    func getBestSetDataPoints() -> [ChartDataPair] {
        let values = lifts.map(generateBestSetDataPair)
        return values
    } 
    private func generateBestSetDataPair(from lift: Lift) -> ChartDataPair {
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
                prTimeInterval = lift.workout!.startDate.timeIntervalSinceReferenceDate
            }
            prDataPoints.append(ChartDataPair(timeInterval: prTimeInterval, weight: prWeight))
        }
        
        return prDataPoints
    } 
    
    
}
