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
                            .foregroundColor(heartRateSFSymbolColor(for: healthKitModel.latestHeartRate))
                            .font(.system(size: 24))
                    }
                } .listRowBackground(
                    RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
                        .fill(heartRateCell(for: healthKitModel.latestHeartRate).gradient)
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
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                } .listRowBackground(
                    RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
                        .fill(variabilityCell(for: healthKitModel.latestHeartRateVariability).gradient)
                        .padding(2)
                )
                
                VStack (alignment: .leading) {
                    Text("Cardio Fitness (V02 Max)")
                        .font(.headline)
                    HStack {
                        Text(healthKitModel.latestV02Max.formatted(
                            .number.precision(.fractionLength(0))))
                        .font(.title2)
                        Image(systemName: "lungs.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                } .listRowBackground(
                    RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
                        .fill(fitnessCell(for: healthKitModel.latestHeartRateVariability).gradient)
                        .padding(2)
                )
                
                VStack (alignment: .leading) {
                    Text("Steps")
                        .font(.headline)
                    HStack {
                        Text(healthKitModel.latestStepCount.formatted(
                            .number.precision(.fractionLength(0))))
                        .font(.title2)
                        Image(systemName: "shoeprints.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                } .listRowBackground(
                    RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
                        .fill(stepsCell(for: Double(healthKitModel.latestStepCount)).gradient)
                        .padding(2)
                )
                
                VStack (alignment: .leading) {
                    Text("BMR")
                        .font(.headline)
                    HStack {
                        Text(healthKitModel.latestRestingEnergy.formatted(
                            .number.precision(.fractionLength(0))))
                        .font(.title2)
                        Image(systemName: "flame.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                } .listRowBackground(
                    RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
                        .fill(stepsCell(for: Double(healthKitModel.latestStepCount)).gradient)
                        .padding(2)
                )
                
                VStack (alignment: .leading) {
                    Text("Active Cals")
                        .font(.headline)
                    HStack {
                        Text(healthKitModel.latestActiveEnergy.formatted(
                            .number.precision(.fractionLength(0))))
                        .font(.title2)
                        Image(systemName: "flame.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                } .listRowBackground(
                    RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
                        .fill(calsCell(for: Double(healthKitModel.latestActiveEnergy)).gradient)
                        .padding(2)
                )
            }
        }
    }
    
    func heartRateSFSymbolColor(for heartRate: Double) -> Color {
        if heartRate > 100 {
            return Color.white
        } else {
            return Color.red
        }
    }
    // Helper function to determine background color based on heart rate
    func heartRateCell(for heartRate: Double) -> Color {
        
        if (heartRate > 100) { return Color.red }
        else { return Color.green }
        
    }
    
    func variabilityCell(for heartRateVariability: Double) -> Color {
        
        if (heartRateVariability > 65) { return Color.blue }
        else { return Color.yellow }
        
    }
    
    func fitnessCell(for cardioFitness: Double) -> Color {
        
        if (cardioFitness > 50) { return Color.green }
        else { return Color.yellow }
        
    }
    
    func stepsCell(for steps: Double) -> Color {
        
        if (steps > 10000) { return Color.green }
        else { return Color.yellow }
        
    }
    
    func bmrCell(for bmr: Double) -> Color {
        
        if (bmr > 2000) { return Color.yellow }
        else { return Color.green }
        
    }
    
    func calsCell(for cals: Double) -> Color {
        
        if (cals > 500) { return Color.blue }
        else { return Color.yellow }
        
    }
}

#Preview {
    if #available(watchOS 9.0, *) {
        HealthKitPage()
    } else {
        // Fallback on earlier versions
    }
}
