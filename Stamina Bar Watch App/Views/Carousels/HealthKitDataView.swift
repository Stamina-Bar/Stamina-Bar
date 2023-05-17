//
//  HealthKitDataView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 6/10/23.
//

import Foundation
import SwiftUI
import HealthKit

struct HealthKitDataView: View {
    
    @State private var userAge: Int = 0
    let legacyHealthStore = HKHealthStore()
    @State private var isPremiumFeaturesHidden = true
    @State private var legacyRestingEnergy: Double = 0.0
    @State private var legacyActiveEnergy: Double = 0.0
    @State var heartRateVariability: Double? = nil

    var body: some View {
        VStack {
            //Age
            VStack {
                Text("Daily Cals")
                Text("HRV")
                Text("User age: \(userAge)")
                    .onAppear {
                        UserAgeReader.getUserAge { (age, error) in
                            if let age = age {
                                self.userAge = age
                            } else {
                                // Handle error here
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: Functions
    var totalEnergy: String {
        let total = legacyActiveEnergy + legacyRestingEnergy
        if total >= 1000 {
            let remainder = total.truncatingRemainder(dividingBy: 1000.0) // get the remainder after dividing by 1000
            let thousands = Int(total / 1000.0) // get the number of thousands
            if remainder == 0 { // if there's no remainder, just display the thousands value and "K"
                return "\(thousands)K"
            } else { // otherwise, display the thousands value and the remainder with one decimal point and "K"
                return "\(thousands).\(Int(remainder / 100.0))K"
            }
        } else {
            return String(format: "%.0f", total)
        }
    }

    
    // Execute query to read HRV
    func fetchHeartRateVariability() {
            // check if HealthKit is available on this device
            guard HKHealthStore.isHealthDataAvailable() else {
                print("HealthKit is not available on this device")
                return
            }
                    // read the user's latest heart rate variability data
                    let heartRateVariabilityType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
                    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
                    let query = HKSampleQuery(sampleType: heartRateVariabilityType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                        guard let samples = samples as? [HKQuantitySample], let firstSample = samples.first else {
                            print("No heart rate variability samples available")
                            return
                        }
                        let heartRateVariability = firstSample.quantity.doubleValue(for: .init(from: "ms"))
                        DispatchQueue.main.async {
                            self.heartRateVariability = heartRateVariability
                        }
                    }
                    legacyHealthStore.execute(query)
        }
    
    // Execute query to retrieve basal energy
    func startLegacyRestingEnergyQuery() {
        let restingEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        let query = HKStatisticsQuery(quantityType: restingEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to retrieve resting energy data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.legacyRestingEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
        }
        legacyHealthStore.execute(query)
    }
    
    // Execute query to retrieve active energy
    private func startLegacyActiveEnergyQuery() {
        let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        let query = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to retrieve active energy data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.legacyActiveEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
        }
        legacyHealthStore.execute(query)
    }
    
    
    
}


