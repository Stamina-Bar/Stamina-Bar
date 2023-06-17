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
    @EnvironmentObject var workoutManager: WorkoutManager

    // Data Fields
    let legacyHealthStore = HKHealthStore()
    @State private var legacyRestingEnergy: Double = 0.0
    @State private var legacyActiveEnergy: Double = 0.0
    @State private var previousVO2Max: Double? = nil
    @State var heartRateVariability: Double? = nil
    @State private var isLoaded: Bool = false
    @State private var vo2Max: Double = 0.0
    @State private var userAge: Int = 0
    @State private var timer: Timer?

    
    var body: some View {
        VStack (alignment: .leading) {
            // HRV
            HStack {
                Image(systemName: "waveform.path.ecg")
                    .foregroundColor(.blue)
                Text("HRV: ")
                Text("\(Int(heartRateVariability ?? 143))")
            } ; Divider()
            
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("Total Cals: ")
                Text("\(getTotalEnergy)")
            } ; Divider()
        
            if workoutManager.selectedWorkout == .other {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.red)
                    Text("Cals: 99")
//                    Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
//                        .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle:
//                                .number.precision(.fractionLength(0)))))

                } ; Divider()
            }
        
          
            
            
            HStack {
                Image(systemName: "lungs.fill")
                    .foregroundColor(.green)
                Text("VO2 MAX: ")
                Text(vo2Max == 0 ? "49" : String(format: "%.0f", vo2Max))
            }
                        
//            Text("User age: \(userAge)")
//                .onAppear {
//                    UserAgeReader.getUserAge { (age, error) in
//                        if let age = age {
//                            self.userAge = age
//                        } else {
//                            // Handle error here
//                        }
//                    }
//                }
        }
        .onAppear {
            // get HRV
            startLegacyRestingEnergyQuery()
            startLegacyActiveEnergyQuery()
            fetchHeartRateVariability()
            loadVO2Max()
            startTimer()
        }
    }

    // MARK: Functions
    var getTotalEnergy: String {
        let total = legacyActiveEnergy + legacyRestingEnergy
        // Formats 999 to 1.0K, 2.7K, 12.2K etc
        if total >= 1000 {
            let remainder = total.truncatingRemainder(dividingBy: 1000.0)
            let thousands = Int(total / 1000.0) // get the number of thousands
            if remainder == 0 {
                return "\(thousands)K"
            } else {
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
    
    func loadVO2Max() {
            let vo2MaxType = HKObjectType.quantityType(forIdentifier: .vo2Max)!
            let sampleQuery = HKSampleQuery(sampleType: vo2MaxType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
                if let vo2Max = results?.first as? HKQuantitySample {
                    self.previousVO2Max = self.vo2Max
                    self.vo2Max = vo2Max.quantity.doubleValue(for: HKUnit(from: "ml/kg*min"))
                    self.isLoaded = true
                }
            }
            legacyHealthStore.execute(sampleQuery)
        }
    
    // Get's HRV every 10 min
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { _ in
            fetchHeartRateVariability()
            HapticManager.successHaptic()
            timer?.invalidate()
            timer = nil
            startTimer() // Start a new timer after each trigger
            
        }
    }

    
    
    
}


