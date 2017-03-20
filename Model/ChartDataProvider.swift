import Foundation
import RealmSwift

struct ChartDataPair {
    let timeInterval: TimeInterval
    let weight: Double
}


final class ChartDataProvider {
    let liftName: String
    init(liftName: String) {
        self.liftName = liftName
    }
    
    func getChartDataPoints() -> [ChartDataPair] {
        let objects = getRealmObjects()
        let values = objects.map(generateChartDataPair)
        return values
    }
    
    private func getRealmObjects() -> [Lift] {
        return RLM.objects(type: Lift.self).filter { $0.name == self.liftName }.sorted { $0.workout!.startDate < $1.workout!.startDate }
    }
    private func generateChartDataPair(from lift: Lift) -> ChartDataPair {
        let timeInterval = lift.workout!.startDate.timeIntervalSinceReferenceDate
        let weight = lift.sets.last?.completedWeight ?? 0
        return ChartDataPair(timeInterval: timeInterval, weight: weight)
    }
    
}
