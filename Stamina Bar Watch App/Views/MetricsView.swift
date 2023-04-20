//
//  MetricsView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.
//

import SwiftUI
import HealthKit

struct MetricsView: View {
    // MARK: Data Fields
    @EnvironmentObject var workoutManager: WorkoutManager
    
    // Fields to display from Health app
    let legacyHealthStore = HKHealthStore()
    @State private var isPremiumFeaturesHidden = true
    @State private var legacyRestingEnergy: Double = 0.0
    @State private var legacyActiveEnergy: Double = 0.0
    @State private var previousVO2Max: Double? = nil
    @State var heartRateVariability: Double? = nil
    @State private var vo2Max: Double = 0.0
    @State private var isLoaded = false
    let staminaBarView = StaminaBarView()
    
    // Adds basal + active energy
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
    
    var body: some View {
        ScrollView {
            // MARK: Outdoor workout selected
            if workoutManager.selectedWorkout == .running || workoutManager.selectedWorkout == .cycling || workoutManager.selectedWorkout == .walking || workoutManager.selectedWorkout == .hiking {
                TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                     isPaused: workoutManager.session?.state == .paused)) { context in
                    VStack(alignment: .leading) {
                        // Timer
                        ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                            .foregroundStyle(.yellow)
                        // tap to hide Calories burned - toggle on initial
                        if isPremiumFeaturesHidden {
                            Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                                .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                        }
                        // Stamina Bar
                        (staminaBarView.visualizeHeartRate(data: workoutManager.heartRate) as AnyView)
                        // Distance
                        Text(Measurement(value: workoutManager.distance, unit: UnitLength.miles).formatted(.measurement(width: .abbreviated, usage: .road, numberFormatStyle: .number.precision(.fractionLength(2)))))
                    }
                    .onTapGesture(perform: {
                        self.isPremiumFeaturesHidden.toggle()
                    })
                    .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .ignoresSafeArea(edges: .bottom)
                    .scenePadding()
                }
            } // end outdoor workout selected
            
            // MARK: Stamina Bar selected
            else if workoutManager.selectedWorkout == .other {
                TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                     isPaused: workoutManager.session?.state == .paused)) { context in
                    VStack(alignment: .trailing) {
                        Spacer(minLength: 50)
                        HStack {
                            // Total Calories - toggle on initial
                            if isPremiumFeaturesHidden {
                                Text("\(totalEnergy) CAL")
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                            }
                            Divider()
                            // HRV - toggle off initial
                            if !isPremiumFeaturesHidden {
                                Text("\(Int(heartRateVariability ?? 0))")
                                Image(systemName: "waveform.path.ecg")
                                    .foregroundColor(.blue)
                                Divider()
                            }
                            HStack {
                                // V02 max - toggle off initial - displays arrow up or down based on trend
                                if !isPremiumFeaturesHidden {
                                    Text("\(vo2Max, specifier: "%.0f")")
                                    if let previousVO2Max = previousVO2Max {
                                        Image(systemName: previousVO2Max <= vo2Max ? "arrow.up" : "arrow.down")
                                            .foregroundColor(previousVO2Max <= vo2Max ? .green : .red)
                                    }
                                }
                            }
                        }
                        .onTapGesture {
                            // Toggles Data Fields
                            self.isPremiumFeaturesHidden.toggle()
                        }
                    
                        // Stamina Bar and Heart Rate
                        VStack (alignment: .trailing) {
                            (staminaBarView.visualizeHeartRate(data: workoutManager.heartRate) as AnyView)
                            HStack {
                                Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " BPM")
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .onAppear() {
                        authorizeLegacyHealthKit()
                        startLegacyActiveEnergyQuery()
                        startLegacyRestingEnergyQuery()
                        fetchHeartRateVariability()
                        loadVO2Max()
                    }
                }
            } // end stamina bar selected
            
            // MARK: Indoor workout selected
            else {
                TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                     isPaused: workoutManager.session?.state == .paused)) { context in
                    VStack(alignment: .leading) {
                        // timer
                        ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                            .foregroundStyle(.yellow)
                        // calories burned - toggle on initial
                        if isPremiumFeaturesHidden {
                        Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                            .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                        }
                        (staminaBarView.visualizeHeartRate(data: workoutManager.heartRate) as AnyView)
                    }
                    .onTapGesture {
                        self.isPremiumFeaturesHidden.toggle()
                    }
                    .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .ignoresSafeArea(edges: .bottom)
                    .scenePadding()
                }
            }
        }
    }
    
    #warning("maybe can be deleted")
    // Authorize to see user Energy burned w/o prompting user again
    private func authorizeLegacyHealthKit() {
        let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let restingEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        legacyHealthStore.requestAuthorization(toShare: nil, read: Set([activeEnergyType, restingEnergyType])) { (success, error) in
            if success {
                print("Successfully authorized to read active and resting energy data")
            } else {
                print("Failed to authorize to read active and resting energy data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
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
    
    // Execute query to retrieve basal energy
    private func startLegacyRestingEnergyQuery() {
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

    // Execute query to read Cardio Fitness (VO2 Max)
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
}

// Default code
struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView().environmentObject(WorkoutManager())
    }
}

// Workout builder helper
private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool

    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate,
                                                    by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
    
}

