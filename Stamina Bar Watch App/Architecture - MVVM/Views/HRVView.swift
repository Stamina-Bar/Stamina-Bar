//
//  HRVView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 3/17/25.
//


import SwiftUI

struct HRVView: View {
    @ObservedObject var healthKitModel: HealthKitModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("HRV")
                .font(.headline)
            HStack {
                Text(healthKitModel.latestHeartRateVariability.formatted(.number.precision(.fractionLength(0))))
                    .font(.title2)
                Image(systemName: "waveform.path.ecg")
                    .foregroundColor(.blue)
                    .font(.system(size: 24))
            }
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.gradient.opacity(0.5))
                .padding(2)
        )
        .accessibilityEnhanced(
            label: "HRV: \(healthKitModel.latestHeartRateVariability)",
            hint: "Displays the latest heart rate variability measured using HealthKit"
        )
    }
}
