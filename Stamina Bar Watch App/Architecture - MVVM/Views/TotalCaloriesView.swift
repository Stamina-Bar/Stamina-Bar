//
//  TotalCaloriesView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 3/17/25.
//

import SwiftUI

struct TotalCaloriesView: View {
    @ObservedObject var healthKitModel: HealthKitModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Total Cals")
                .font(.headline)
            HStack {
                Text(healthKitModel.totalCalories.formatted(.number.precision(.fractionLength(0))))
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
