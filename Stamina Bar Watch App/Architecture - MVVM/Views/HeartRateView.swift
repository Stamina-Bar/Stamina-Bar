//
//  HeartRateView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 3/17/25.
//


import SwiftUI

struct HeartRateView: View {
    @ObservedObject var healthKitModel: HealthKitModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Heart Rate")
                .font(.headline)
            HStack {
                Text(healthKitModel.latestHeartRate.formatted(.number.precision(.fractionLength(0))))
                    .font(.title2)
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 24))
                    .accessibilityHidden(true)
            }
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.gradient.opacity(0.5))
                .padding(2)
        )
        .accessibilityEnhanced(
            label: "Heart Rate: \(healthKitModel.latestHeartRate) beats per minute",
            hint: "Displays the latest heart rate measured using HealthKit"
        )
    }
}
