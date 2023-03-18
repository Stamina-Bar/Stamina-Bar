//
//  StartView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.
//

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
        WorkoutType(workoutType: .other, imageName: "bolt.heart"),
        WorkoutType(workoutType: .cycling, imageName: "bicycle"),
        WorkoutType(workoutType: .running, imageName: "figure.run"),
        WorkoutType(workoutType: .walking, imageName: "figure.walk"),
        WorkoutType(workoutType: .yoga, imageName: "figure.cooldown"),
        WorkoutType(workoutType: .traditionalStrengthTraining, imageName: "figure.strengthtraining.traditional")
    ]

    var body: some View {
        List {
            ForEach(Array(workoutTypes.enumerated()), id: \.1.id) { (index, workoutType) in
                NavigationLink(destination: SessionPagingView(),
                               tag: workoutType.workoutType,
                               selection: $workoutManager.selectedWorkout) {
                    HStack {
                        Image(systemName: workoutType.imageName)
                            .foregroundColor(.red)
                        Text(workoutType.workoutType.name)
                    }
                    .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
                }
                if index == 0 {
                    Divider()
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
        default:
            return ""
        }
    }
}
