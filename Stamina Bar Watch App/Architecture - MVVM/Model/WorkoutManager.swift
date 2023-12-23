//
//  WorkoutManager.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/9/23.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    
    // Good for dynamically checking the type of workout a user is doing
    var selectedWorkout: HKWorkoutActivityType? {
        didSet {
            guard let selectedWorkout = selectedWorkout else { return }
            startWorkout(workoutType: selectedWorkout)
        }
    }
    
    @Published var showingSummaryView: Bool = false {
        didSet {
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }
    
    var builder: HKLiveWorkoutBuilder?
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    
    // Start the workout.
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        
        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            return
        }
        
        // Setup session and builder.
        session?.delegate = self
        builder?.delegate = self
        
        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                      workoutConfiguration: configuration)
        
        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started.
        }
    }
    
    // Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .vo2Max)!,
            HKObjectType.activitySummaryType()
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { [weak self] (success, error) in
            if success {
                // Perform additional tasks or fetches here if necessary
                self?.fetchMostRecentHRV()
                self?.fetchDailyBasalEnergyBurn()
                self?.fetchDailyActiveEnergyBurned()
                self?.fetchDailyStepCount()
                self?.fetchMostRecentVO2Max()
            } else {
                // Handle the error if permissions are not granted
            }
        }
    }
    
    // MARK: - Session State Control
    
    // The app's workout state.
    @Published var running = false
    
    func togglePause() {
        if running == true {
            self.pause()
        } else {
            resume()
        }
    }
    
    func pause() {
        session?.pause()
    }
    
    func resume() {
        session?.resume()
    }
    
    func endWorkout() {
        session?.end()
        showingSummaryView = true
    }
    
    // MARK: - Workout Metrics
    @Published var heartRateVariability: Double = 0
    @Published var averageHeartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var basalEnergy: Double = 0
    @Published var totalDailyEnergy: Double = 0
    @Published var currentVO2Max: Double = 0
    @Published var previousVO2Max: Double = 0
    @Published var dailyStepCount: Int = 0
    @Published var heartRate: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let mileUnit = HKUnit.mile()
                self.distance = statistics.sumQuantity()?.doubleValue(for: mileUnit) ?? 0
            default:
                return
            }
        }
    }
    
    func resetWorkout() {
        heartRateVariability = 0
        selectedWorkout = nil
        activeEnergy = 0
        basalEnergy = 0
        totalDailyEnergy = 0
        dailyStepCount = 0
        heartRate = 0
        distance = 0
        builder = nil
        workout = nil
        session = nil
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }
        
        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
        
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            // Update the published values on the main thread.
            DispatchQueue.main.async {
                self.updateForStatistics(statistics)
            }
        }
    }

    
    func fetchMostRecentHRV() {
        // Define the Heart Rate Variability type using HealthKit's standard nomenclature.
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            print("HRV type is not available.")
            return
        }
        // Create a predicate to fetch samples from the distant past to the current date.
        // This ensures we get the most recent sample.
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        
        // Define a sort descriptor to sort the samples by start date in descending order.
        // This ensures the most recent sample is first.
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Create a query to fetch Heart Rate Variability samples.
        // Limit the query to return only the most recent sample (limit: 1).
        let query = HKSampleQuery(sampleType: hrvType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { [weak self] (_, samples, _) in
            // Process the query results on the main thread to update the UI.
            DispatchQueue.main.async {
                // Ensure the samples are of the correct type (HKQuantitySample) and get the first one.
                guard let samples = samples as? [HKQuantitySample], let mostRecentSample = samples.first else {
                    return
                }
                // Update the heartRateVariability property with the latest HRV value.
                // Convert the HRV value to a double value in milliseconds (ms).
                self?.heartRateVariability = mostRecentSample.quantity.doubleValue(for: HKUnit(from: "ms"))
            }
        }
        // Execute the query on the health store.
        self.healthStore.execute(query)
    }
    
    // Execute query to retrieve basal (resting) energy
    func fetchDailyBasalEnergyBurn() {
        // Safely unwrap the restingEnergyType to avoid runtime crashes
        guard let restingEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned) else {
            print("Basal energy burn type is not available")
            return
        }
        
        let now = Date()
        // Using Calendar.current to get the start of the day is a good practice
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        // Creating a predicate for the time range from the start of the day to now
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        
        // Initializing a HKStatisticsQuery to fetch cumulative basal energy data
        let query = HKStatisticsQuery(quantityType: restingEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            // Robust error handling for nil results or errors
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to retrieve resting energy data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Converting the sum of basal energy burned to kilocalories
            self.basalEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
        }
        
        // Executing the query on the HealthKit store
        healthStore.execute(query)
    }
    
    // Execute query to retrieve active energy
    func fetchDailyActiveEnergyBurned() {
        // Define the quantity type for active energy burned
        guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            print("Daily active energy burn type is not available")
            return
        }
        
        // Get the current date and time
        let now = Date()
        
        // Determine the start of the current day
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        // Create a predicate to filter the HealthKit data between the start of the day and now
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        
        // Initialize a statistics query for the active energy type with the specified predicate
        // Configure it to calculate a cumulative sum of the active energy burned
        let query = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            // Check if the query result is available and successfully retrieve the sum quantity
            guard let result = result, let sum = result.sumQuantity() else {
                // Print an error message if the data retrieval fails
                print("Failed to retrieve active energy data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Convert the sum quantity to kilocalories and store it in the legacyActiveEnergy property
            self.totalDailyEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
        }
        
        // Execute the query on the HealthKit store
        healthStore.execute(query)
    }
    
    // Fetch the current day's step count
    func fetchDailyStepCount() {
        // Define the step count data type
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            print("Step Count type is not available.")
            return
        }
        
        // Set the time range for today
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        // Create a query to fetch the cumulative step count
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Error fetching step count. Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Update the step count
            DispatchQueue.main.async {
                self.dailyStepCount = Int(sum.doubleValue(for: HKUnit.count()))
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    // Fetch the most recent VO2 Max value from HealthKit
    func fetchMostRecentVO2Max() {
        // Define the VO2 Max data type
        guard let vo2MaxType = HKObjectType.quantityType(forIdentifier: .vo2Max) else {
            print("VO2 Max type is not available.")
            return
        }
        
        // Create a sort descriptor to fetch the latest sample
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        // Build a query to fetch the most recent VO2 Max sample
        let query = HKSampleQuery(sampleType: vo2MaxType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let vo2MaxSample = results?.first as? HKQuantitySample else {
                print("Failed to retrieve VO2 Max data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Update VO2 Max values
            DispatchQueue.main.async {
                self.previousVO2Max = self.currentVO2Max
                self.currentVO2Max = vo2MaxSample.quantity.doubleValue(for: HKUnit(from: "ml/kg*min"))
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    
}
