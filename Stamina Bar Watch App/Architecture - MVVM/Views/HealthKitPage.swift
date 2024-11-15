//
//  HealthKitPage.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 11/15/24.
//

import SwiftUI

struct HealthKitPage: View {
    let staminaCalculationAlgorithm = StaminaCalculationAlgorithm()
    @ObservedObject var healthKitModel = HealthKitModel()
    var body: some View {
//        _ = [healthKitModel.latestHeartRate, healthKitModel.latestHeartRateVariability, healthKitModel.latestV02Max]
        
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
                   
                }
                
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
    
    
}

#Preview {
    HealthKitPage()
}
