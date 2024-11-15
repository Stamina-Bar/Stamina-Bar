//
//  HealthKitPage.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 11/15/24.
//

import SwiftUI

@available(watchOS 9.0, *)
struct HealthKitPage: View {
    let staminaCalculationAlgorithm = StaminaCalculationAlgorithm()
    @ObservedObject var healthKitModel = HealthKitModel()
    var body: some View {
        
        let (staminaView, staminaPercentage) =
        staminaCalculationAlgorithm.stressFunction(
            heart_rate: healthKitModel.latestHeartRate,
            hrv: healthKitModel.latestHeartRateVariability
        )
        
        VStack(alignment: .leading) {
            staminaView
                .accessibilityElement()
                .accessibilityLabel(
                    Text("Stamina percentage is \(staminaPercentage)%"))
            
            List {
                VStack (alignment: .leading) {
                    Text("Heart Rate")
                        .font(.headline)
                    HStack {
                        Text(healthKitModel.latestHeartRate.formatted(
                            .number.precision(.fractionLength(0))))
                        .font(.title2)
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 24))
                    }
                } .listRowBackground(
                    RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
                        .fill(heartRateCell(for: healthKitModel.latestHeartRate))
                        .padding(2)
                )
                
                VStack (alignment: .leading) {
                    Text("Variability (HRV)")
                        .font(.headline)
                    HStack {
                        Text(healthKitModel.latestHeartRateVariability.formatted(
                            .number.precision(.fractionLength(0))))
                        .font(.title2)
                        Image(systemName: "waveform.path.ecg")
                            .foregroundColor(.blue)
                            .font(.system(size: 24))
                    }
                }
            }
        }
    }
    
    // Helper function to determine background color based on heart rate
       func heartRateCell(for heartRate: Double) -> Color {
           if heartRate > 100 {
               return Color.red.opacity(0.2) // Light red for high heart rate
           } else if heartRate < 60 {
               return Color.blue.opacity(0.2) // Light blue for low heart rate
           } else {
               return Color.green.opacity(0.2) // Light green for normal heart rate
           }
       }
}

#Preview {
    if #available(watchOS 9.0, *) {
        HealthKitPage()
    } else {
        // Fallback on earlier versions
    }
}
