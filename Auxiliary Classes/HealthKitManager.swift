import HealthKit

func not(bool: Bool) -> Bool {
    return !bool
}
class HealthKitManager {
    let healthKitStore = HKHealthStore()
    
    func authorizeHealthKit(completion: @escaping ((_ success: Bool, _ error: Error?) -> Void)) {
       
        let toWriteTypes: Swift.Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!]
        healthKitStore.requestAuthorization(toShare: toWriteTypes, read: nil, completion: completion)
    }
}
