//
//  V02MaxView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 3/17/25.
//


import SwiftUI

struct V02MaxView: View {
    @ObservedObject var healthKitModel: HealthKitModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("V02 Max")
                .font(.headline)
            HStack {
                Text(healthKitModel.latestV02Max.formatted(.number.precision(.fractionLength(1))))
                    .font(.title2)
                Image(systemName: "figure.run")
                    .foregroundColor(.green)
                    .font(.system(size: 24))
            }
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.gradient.opacity(0.5))
                .padding(2)
        )
        .accessibilityEnhanced(
            label: "V02 Max: \(healthKitModel.latestV02Max)",
            hint: "Displays the latest V02 Max measured using HealthKit"
        )
    }
}
