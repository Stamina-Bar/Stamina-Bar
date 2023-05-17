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
    @EnvironmentObject var workoutManager: WorkoutManager
    var workoutTypes: [WorkoutType] = [
        WorkoutType(workoutType: .other, imageName: "custom.StaminaBar"),
        WorkoutType(workoutType: .walking, imageName: "custom.walk"),
        WorkoutType(workoutType: .running, imageName: "custom.run"),
        WorkoutType(workoutType: .yoga, imageName: "custom.yoga"),
        WorkoutType(workoutType: .traditionalStrengthTraining, imageName: "custom.strengthTraining"),
        WorkoutType(workoutType: .hiking, imageName: "custom.hike"),
        WorkoutType(workoutType: .highIntensityIntervalTraining, imageName: "custom.HIIT"),
        WorkoutType(workoutType: .cycling, imageName: "custom.bike"),

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
            return "Stamina Bar"
        case .running:
            return "Run"
        case .cycling:
            return "Bike"
        case .walking:
            return "Walk"
        case .yoga:
            return "Yoga"
        case .traditionalStrengthTraining:
            return "Strength Training"
        case .hiking:
            return "Hiking"
        case .highIntensityIntervalTraining:
            return "High Intensity Interval Training HIIT"
        default:
            return ""
        }
    }
}
