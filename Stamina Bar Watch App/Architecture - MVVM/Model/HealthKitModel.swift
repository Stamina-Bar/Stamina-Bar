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
    private var activeEnergyAnchor: HKQueryAnchor?
    private var processedActiveSamples: Set<UUID> = []
    private var restingEnergyAnchor: HKQueryAnchor?
    @Published var userAgeInYears: Int = 0
    @State private var previousV02Max: Double?
    @Published var isRespiratoryRateAvailable: Bool = false
    @Published var latestRespiratoryRate: Double = 0
    private var respiratoryRateQuery: HKAnchoredObjectQuery?
    
    var totalCalories: Double {
        return latestActiveEnergy + latestRestingEnergy
    }
    
    enum Trend {
        case up, down, same
    }
    
    init() {
        healthStore = HKHealthStore()
        requestAuthorization()
        stepsObserver()
    }
    
    func requestAuthorization() {
        
        let readTypes: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .vo2Max)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!
        ]
        
        healthStore?.requestAuthorization(toShare: [], read: readTypes) { success, error in
            if success {
                self.startHeartRateVariabilityQuery()
                self.startHeartRateQuery()
                self.startV02MaxQuery()
                self.fetchDailyStepCount()
                self.startRestingEnergyQuery()
                self.startActiveEnergyQuery()
                self.startRespiratoryRateQuery()
            }
        }
    }
    
    func startActiveEnergyQuery() {
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKAnchoredObjectQuery(type: activeEnergyType,
                                          predicate: predicate,
                                          anchor: activeEnergyAnchor,
                                          limit: HKObjectQueryNoLimit) { query, samples, _, newAnchor, error in
            guard error == nil else { return }
            self.activeEnergyAnchor = newAnchor
            self.processActiveSamples(samples)
        }
        
        query.updateHandler = { query, samples, _, newAnchor, error in
            guard error == nil else { return }
            self.activeEnergyAnchor = newAnchor
            self.processActiveSamples(samples)
        }
        
        healthStore?.execute(query)
    }
        
    private func processActiveSamples(_ samples: [HKSample]?) {
        guard let energySamples = samples as? [HKQuantitySample] else { return }
        
        // Filter out already processed samples using their unique UUIDs
        let newSamples = energySamples.filter { !processedActiveSamples.contains($0.uuid) }
        processedActiveSamples.formUnion(newSamples.map { $0.uuid })
        
        let newEnergy = newSamples.reduce(0.0) { result, sample in
            result + sample.quantity.doubleValue(for: HKUnit.kilocalorie())
        }
        
        DispatchQueue.main.async {
            if newEnergy > 0 {
                self.latestActiveEnergy += newEnergy
            }
        }
    }
        
    func startRestingEnergyQuery() {
        guard let restingEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned) else {
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let statisticsQuery = HKStatisticsQuery(quantityType: restingEnergyType,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum) { _, statistics, error in
            guard error == nil else { return }
            let newEnergy = statistics?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0.0
            
            DispatchQueue.main.async {
                if newEnergy > 0 {
                    self.latestRestingEnergy = newEnergy // Replace instead of adding
                }
            }
        }
        
        healthStore?.execute(statisticsQuery)
    }

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
    
    func updateStepCounts(_ samples: [HKSample]?) {
        guard let stepSamples = samples as? [HKQuantitySample] else {
            return
        }
        
        DispatchQueue.main.async {
            let totalSteps = stepSamples.reduce(0) { (result, sample) -> Int in
                return result + Int(sample.quantity.doubleValue(for: HKUnit.count()))
            }
            self.latestStepCount = totalSteps
        }
    }

    func stepsObserver() {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let query = HKObserverQuery(sampleType: stepCountType, predicate: nil) { [weak self] _, completionHandler, error in
            if let error = error {

            }
            self?.fetchDailyStepCount()
            completionHandler()
        }
        
        healthStore?.execute(query)
        
        healthStore?.enableBackgroundDelivery(for: stepCountType, frequency: .immediate, withCompletion: { success, error in
            if let error = error {

            } else if success {
            }
        })
    }
        
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
    
    private func updateVO2Max(_ samples: [HKSample]?) {
        guard let vo2MaxSamples = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            if let latestSample = vo2MaxSamples.last?.quantity.doubleValue(for: HKUnit(from: "ml/kg*min")) {

                self.previousV02Max = self.latestV02Max
                self.latestV02Max = latestSample
            }
        }
    }
    
    private func readAge(completion: @escaping (Int, Error?) -> Void) {
        do {
            let dateOfBirthComponents = try healthStore?.dateOfBirthComponents()
            
            let defaultDateComponents = DateComponents(year: 0, month: 1, day: 1)
            
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
    
    private func updateHeartRates(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            self.latestHeartRate = heartRateSamples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0
            self.isHeartRateAvailable = !heartRateSamples.isEmpty
        }
    }

    private func updateHeartRateVariability(_ samples: [HKSample]? ) {
        guard let heartRateVariabilitySample = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            self.latestHeartRateVariability = heartRateVariabilitySample.last?.quantity.doubleValue(for: HKUnit(from: "ms")) ?? 0
            self.isHeartRateVariabilityAvailable = !heartRateVariabilitySample.isEmpty
        }
    }
    
    func startRespiratoryRateQuery() {
        guard let respiratoryRateType = HKObjectType.quantityType(forIdentifier: .respiratoryRate) else { return }
        
        let query = HKAnchoredObjectQuery(type: respiratoryRateType,
                                          predicate: nil,
                                          anchor: nil,
                                          limit: HKObjectQueryNoLimit) { query, samples, deletedObjects, anchor, error in
            self.updateRespiratoryRate(samples)
        }
        
        query.updateHandler = { query, samples, deletedObjects, anchor, error in
            self.updateRespiratoryRate(samples)
        }
        
        healthStore?.execute(query)
        self.respiratoryRateQuery = query
    }
    
    private func updateRespiratoryRate(_ samples: [HKSample]?) {
        guard let respiratoryRateSamples = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            self.latestRespiratoryRate = respiratoryRateSamples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0
            self.isRespiratoryRateAvailable = !respiratoryRateSamples.isEmpty
        }
    }
}
