//
//  RespiratoryRateView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 3/17/25.
//


import SwiftUI

struct RespiratoryRateView: View {
    @ObservedObject var healthKitModel: HealthKitModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Respiratory Rate")
                .font(.headline)
            HStack {
                Text(healthKitModel.latestRespiratoryRate.formatted(.number.precision(.fractionLength(1))))
                    .font(.title2)
                Image(systemName: "lungs.fill")
                    .foregroundColor(.teal)
                    .font(.system(size: 24))
                    .accessibilityHidden(true)
            }
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.gradient.opacity(0.5))
                .padding(2)
        )
    }
}
