//
//  HealthKitHelper.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 1/30/23.
//  Special thanks to Anastasia Ryabenko for her public repo on GitHub
//  called Heart Rate. I used her code here in my app.

import Foundation
import SwiftUI
import HealthKit

class HealthKitHelper: ObservableObject {
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    
    @Published var currentHeartRate: Int = 0
    @Published var minHeartRate: Int = -1
    @Published var maxHeartRate: Int = 0
    
    init() {
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }
            self.process(samples, type: quantityTypeIdentifier)
        }
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        healthStore.execute(query)
    }
 
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            DispatchQueue.main.async {
                self.currentHeartRate = Int(lastHeartRate)
                if self.maxHeartRate < self.currentHeartRate {
                    self.maxHeartRate = self.currentHeartRate
                }
                if self.minHeartRate == -1 || self.minHeartRate > self.currentHeartRate {
                    self.minHeartRate = self.currentHeartRate
                }
            }
        }
    }
    
}
