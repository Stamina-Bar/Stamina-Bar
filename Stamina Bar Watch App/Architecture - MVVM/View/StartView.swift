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
    let workoutSupportingImage: String
}

struct StartView: View {
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @EnvironmentObject var workoutManager: WorkoutManager
    var workoutTypes: [WorkoutType] = [
        WorkoutType(workoutType: .other, workoutSupportingImage: "custom.StaminaBar")
    ]
    
    var body: some View {
        VStack {
            Spacer()
            if let workoutType = workoutTypes.first {
                NavigationLink(destination: SessionPagingView(),
                               tag: workoutType.workoutType,
                               selection: $workoutManager.selectedWorkout) {
                    HStack {
                        Image(workoutType.workoutSupportingImage)
                        Text("Start Stamina Bar")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 30) .stroke(Color.blue, lineWidth: 2))
            }
            Spacer()
        }
        .navigationBarTitle("Stamina Bar")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ConditionalScrollIndicatorModifier(shouldHide: shouldShowOnboarding))
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        })
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(WorkoutManager())
    }
}

struct ConditionalScrollIndicatorModifier: ViewModifier {
    var shouldHide: Bool
    
    func body(content: Content) -> some View {
        if #available(watchOS 9.0, *) {
            return AnyView(content.scrollIndicators(shouldHide ? .hidden : .visible))
        } else {
            return AnyView(content)
        }
    }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
    
    var name: String {
        switch self {
        case .other:
            return "Start Stamina Bar"
        default:
            return ""
        }
    }
}
