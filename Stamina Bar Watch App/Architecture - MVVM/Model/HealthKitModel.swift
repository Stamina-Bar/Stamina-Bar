//
//  HealthKitModel.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 7/5/24.
//

import Foundation
import HealthKit
import SwiftUI

class HealthKitModel: ObservableObject {
    var healthStore: HKHealthStore?
    var query: HKQuery?
    
    @Published var isHeartRateVariabilityAvailable: Bool = false
    @Published var isHeartRateAvailable: Bool = false
    @Published var isV02MaxAvailable: Bool = false
    @Published var latestHeartRateVariability: Double = 0
    @Published var latestHeartRate: Double = 0.0
    @Published var latestV02Max: Double = 0.0
    @Published var latestStepCount: Int = 0
    @Published var latestActiveEnergy: Double = 0.0
    @Published var latestRestingEnergy: Double = 0.0
    @Published var userAgeInYears: Int = 0
    
    @Published var healthDataAvailable: Bool = true  // Default to true

    init() {
        
        
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            requestAuthorization()
            startStepCountObserver()
        } else {
            healthDataAvailable = false
        }
    }
    
    func requestAuthorization() {
        
        let readTypes: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .vo2Max)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!
//            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
            //            HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
            //            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        
        healthStore?.requestAuthorization(toShare: [], read: readTypes) { success, error in
            if success {
                self.startHeartRateVariabilityQuery()
                self.startHeartRateQuery()
                self.startV02MaxQuery()
                self.fetchDailyStepCount()
                self.readAge { age, error in
                    if error != nil {
//                        print("Failed to read age: \(error.localizedDescription)")
                    } else {
//                        print("User's age is \(age)")
                    }
                }
            } else {
//                print("Authorization failed")
            }
        }
    }
    //    MARK: Resting Energy 
    //    func startRestingEnergyQuery() {
    //        guard let restingEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned) else {
    //
    //            return
    //        }
    //
    //        let calendar = Calendar.current
    //        let now = Date()
    //        let startOfDay = calendar.startOfDay(for: now)
    //        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
    //
    //        let query = HKAnchoredObjectQuery(type: restingEnergyType,
    //                                          predicate: predicate,
    //                                          anchor: nil,
    //                                          limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
    //            self.processRestingSamples(samples)
    //        }
    //
    //        query.updateHandler = { query, samples, deletedObjects, anchor, error in
    //            self.processRestingSamples(samples)
    //        }
    //
    //        healthStore?.execute(query)
    //    }
    
    //    private func processRestingSamples(_ samples: [HKSample]?) {
    //        guard let energySamples = samples as? [HKQuantitySample] else {
    //
    //            return
    //        }
    //
    //        let totalEnergy2 = energySamples.reduce(0.0) { (result, sample) -> Double in
    //            return result + sample.quantity.doubleValue(for: HKUnit.kilocalorie())
    //        }
    //
    //        DispatchQueue.main.async {
    //            self.latestRestingEnergy = totalEnergy2
    ////            print("Updated latest resting energy: \(self.latestRestingEnergy) kcal")
    //        }
    //    }
    
    //    MARK: Step Count
    func fetchDailyStepCount() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: .now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let startTime = Date()
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            // Calculate elapsed time
            _ = Date().timeIntervalSince(startTime)
            
            if let sum = result?.sumQuantity() {
                _ = sum.doubleValue(for: HKUnit.count()).rounded()
                DispatchQueue.main.async {
                    self.latestStepCount = Int((sum.doubleValue(for: HKUnit.count())))
                }
            }
        }
        healthStore?.execute(query)
    }
    
    //    MARK: Step Count
    func updateStepCounts(_ samples: [HKSample]?) {
        guard let stepSamples = samples as? [HKQuantitySample] else {
            print("Could not extract step count samples.")
            return
        }
        
        DispatchQueue.main.async {
            let totalSteps = stepSamples.reduce(0) { (result, sample) -> Int in
                return result + Int(sample.quantity.doubleValue(for: HKUnit.count()))
            }
            self.latestStepCount = totalSteps  // This is an Int, so no decimals
        }
    }
    
    // MARK: Step Count Observer Query
        func startStepCountObserver() {
            guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
                return
            }

            let query = HKObserverQuery(sampleType: stepCountType, predicate: nil) { [weak self] _, completionHandler, error in
                if let error = error {
                    print("Observer query failed: \(error.localizedDescription)")
                    return
                }

                // When there's an update in step count, fetch the new data
                self?.fetchDailyStepCount()

                // Notify HealthKit that the query has been handled
                completionHandler()
            }

            // Execute the query to monitor for changes
            healthStore?.execute(query)

            // Enable background delivery to receive updates even when the app is not active
            healthStore?.enableBackgroundDelivery(for: stepCountType, frequency: .immediate, withCompletion: { success, error in
                if let error = error {
                    print("Failed to enable background delivery: \(error.localizedDescription)")
                } else if success {
                    print("Background delivery enabled for step count")
                }
            })
        }
    //    MARK: v02Max
    func startV02MaxQuery() {
        guard let vo2MaxType = HKObjectType.quantityType(forIdentifier: .vo2Max) else { return }
        
        let query = HKAnchoredObjectQuery(type: vo2MaxType,
                                          predicate: nil,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
            self.updateVO2Max(samples)
        }
        
        query.updateHandler = { query, samples, deletedObjects, anchor, error in
            self.updateVO2Max(samples)
        }
        
        healthStore?.execute(query)
        self.query = query
    }
    //    MARK: v02 Max
    private func updateVO2Max(_ samples: [HKSample]?) {
        guard let vo2MaxSamples = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            self.latestV02Max = vo2MaxSamples.last?.quantity.doubleValue(for: HKUnit(from: "ml/kg*min")) ?? 0
        }
    }
    //    MARK: Age
    private func readAge(completion: @escaping (Int, Error?) -> Void) {
        do {
            let dateOfBirthComponents = try healthStore?.dateOfBirthComponents()
            
            // Default dateOfBirthComponents if not available
            let defaultDateComponents = DateComponents(year: 0, month: 1, day: 1)
            
            // Use the date components from HealthKit or default if not available
            let dateOfBirth = dateOfBirthComponents?.date ?? Calendar.current.date(from: defaultDateComponents)!
            
            let calendar = Calendar.current
            let now = Date()
            let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
            
            // Use 0 as default age if calculation fails
            let age = ageComponents.year ?? 0
            completion(age, nil)
        } catch {
            completion(0, error)
        }
    }
    //    MARK: HR
    func startHeartRateQuery() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        let query = HKAnchoredObjectQuery(type: heartRateType,
                                          predicate: nil,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
            self.updateHeartRates(samples)
        }
        
        query.updateHandler = { query, samples, deletedObjects, anchor, error in
            self.updateHeartRates(samples)
        }
        
        healthStore?.execute(query)
        self.query = query
    }
    
    //    MARK: HRV
    func startHeartRateVariabilityQuery() {
        guard let heartRateVariabilityType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return }
        
        let query = HKAnchoredObjectQuery(type: heartRateVariabilityType,
                                          predicate: nil,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
            self.updateHeartRateVariability(samples)
        }
        
        query.updateHandler = { query, samples, deletedObjects, anchor, error in
            self.updateHeartRateVariability(samples)
        }
        
        healthStore?.execute(query)
        self.query = query
    }
    
    //    MARK: HR
    private func updateHeartRates(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            self.latestHeartRate = heartRateSamples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0
            self.isHeartRateAvailable = !heartRateSamples.isEmpty
        }
    }
    
//    MARK: HRV
    private func updateHeartRateVariability(_ samples: [HKSample]? ) {
        guard let heartRateVariabilitySample = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            self.latestHeartRateVariability = heartRateVariabilitySample.last?.quantity.doubleValue(for: HKUnit(from: "ms")) ?? 0
            self.isHeartRateVariabilityAvailable = !heartRateVariabilitySample.isEmpty
        }
    }
}
