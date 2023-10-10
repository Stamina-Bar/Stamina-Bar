//
//  StartView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.

// MARK: - Displays workout types and their respective images


import SwiftUI
import HealthKit

struct WorkoutType: Identifiable {
    var id: HKWorkoutActivityType {
        return workoutType
    }
    let workoutType: HKWorkoutActivityType
    let imageName: String
}

struct StartView: View {
    let legacyHealthStore = HKHealthStore()
    @State var heartRateVariability: Double? = nil
    @State private var timer: Timer?

    @EnvironmentObject var workoutManager: WorkoutManager
    var workoutTypes: [WorkoutType] = [
        WorkoutType(workoutType: .other, imageName: "custom.StaminaBar"),
        WorkoutType(workoutType: .yoga, imageName: "custom.yoga"),
        WorkoutType(workoutType: .walking, imageName: "custom.walk"),
        WorkoutType(workoutType: .running, imageName: "custom.run"),
        WorkoutType(workoutType: .cycling, imageName: "custom.bike"),
        WorkoutType(workoutType: .hiking, imageName: "custom.hike"),
        WorkoutType(workoutType: .highIntensityIntervalTraining, imageName: "custom.HIIT"),
        WorkoutType(workoutType: .traditionalStrengthTraining, imageName: "custom.strengthTraining")
    ]

    var body: some View {
        List {
            ForEach(Array(workoutTypes.enumerated()), id: \.1.id) { (index, workoutType) in
                NavigationLink(destination: SessionPagingView(),
                               tag: workoutType.workoutType,
                               selection: $workoutManager.selectedWorkout) {
                    HStack {
                        Image(workoutType.imageName)
//                        Image(systemName: workoutType.imageName)
                            .foregroundColor(.red)
                        Text(workoutType.workoutType.name)
                    }
                    .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
                }                
            }
        }
        .listStyle(.carousel)
        .navigationBarTitle("Stamina Bar")
        .onAppear {
            workoutManager.requestAuthorization()
            startTimer()
            fetchHeartRateVariability()
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
    
    // Get's HRV every 50 min
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3000, repeats: true) { _ in
            fetchHeartRateVariability()
            //HapticManager.successHaptic()
            timer?.invalidate()
            timer = nil
            startTimer() // Start a new timer after each trigger
            
        }
    }
    
   

}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(WorkoutManager())
    }
}


extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }

    var name: String {
        switch self {
        case .other:
            return "Any"
        case .running:
            return "Jog"
        case .cycling:
            return "Bike"
        case .walking:
            return "Walk"
        case .yoga:
            return "Yoga"
        case .traditionalStrengthTraining:
            return "Weights"
        case .hiking:
            return "Hike"
        case .highIntensityIntervalTraining:
            return "H.I.I.T"
        default:
            return ""
        }
    }
}
