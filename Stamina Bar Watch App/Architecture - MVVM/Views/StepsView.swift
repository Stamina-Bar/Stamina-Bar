//
//  StepsView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 3/17/25.
//


import SwiftUI
struct StepsView: View {
    @ObservedObject var healthKitModel: HealthKitModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Steps")
                .font(.headline)
            HStack {
                Text(healthKitModel.latestStepCount.formatted(.number.precision(.fractionLength(0))))
                    .font(.title2)
                Image(systemName: "shoeprints.fill")
                    .foregroundColor(Color.white.opacity(0.8))
                    .font(.system(size: 24))
            }
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.gradient.opacity(0.5))
                .padding(2)
        )
        .accessibilityEnhanced(
            label: "Steps: \(healthKitModel.latestStepCount) steps",
            hint: "Displays the latest step count measured using HealthKit"
        )
    }
}
