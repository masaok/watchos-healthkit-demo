//
//  HealthDataManager.swift
//  watchos-healthkit-demo Watch App
//

import HealthKit

class HealthDataManager {
    let healthStore = HKHealthStore()
    let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(toShare: [], read: [stepCountType]) { (success, error) in
            completion(success)
        }
    }
    
    func fetchTodayStepCount(completion: @escaping (Double) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }
}
