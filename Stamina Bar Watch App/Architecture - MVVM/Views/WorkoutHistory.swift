//
//  WorkoutHistory.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 12/16/24.
//


import SwiftUI
import HealthKit

struct WorkoutHistory: View {
    @State private var workouts: [HKWorkout] = []
    private let healthStore = HKHealthStore()
    
    var body: some View {
        NavigationView {
            List(workouts, id: \.uuid) { workout in
                VStack(alignment: .leading) {
                    Text(workout.workoutActivityType.name)
                        .font(.headline)
                    Text("Duration: \(workout.duration.formatted(.number.precision(.fractionLength(0)))) seconds")
                    if let calories = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) {
                        Text("Calories: \(calories, specifier: "%.0f") kcal")
                    } else {
                        Text("Calories: N/A")
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Workout History")
            .onAppear(perform: fetchRecentWorkouts)
        }
    }
    
    private func fetchRecentWorkouts() {
        let workoutType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: workoutType,
                                  predicate: nil,
                                  limit: 10,
                                  sortDescriptors: [sortDescriptor]) { query, samples, error in
            if let error = error {
                print("Error fetching workouts: \(error.localizedDescription)")
                return
            }
            
            guard let workouts = samples as? [HKWorkout] else { return }
            
            DispatchQueue.main.async {
                self.workouts = workouts
            }
        }
        
        healthStore.execute(query)
    }
}

extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .running: return "Running"
        case .walking: return "Walking"
        case .cycling: return "Cycling"
        case .swimming: return "Swimming"
        case .yoga: return "Yoga"
        case .other: return "Other"
        default: return "Unknown"
        }
    }
}
