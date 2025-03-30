//
//  RestingCaloriesView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 3/17/25.
//


import SwiftUI
struct RestingCaloriesView: View {
    @ObservedObject var healthKitModel: HealthKitModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Resting Cals")
                .font(.headline)
            HStack {
                Text(healthKitModel.latestRestingEnergy.formatted(.number.precision(.fractionLength(0))))
                    .font(.title2)
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 24))
            }
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.gradient.opacity(0.5))
                .padding(2)
        )
    }
}
