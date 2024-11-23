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
    
    @State private var animatedHeartRate: Double = 0
    @State private var animatedHRV: Double = 0
    @State private var animatedV02Max: Double = 0
    @State private var animatedSteps: Double = 0
    @State private var animatedBMR: Double = 0
    @State private var animatedActiveCals: Double = 0


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
                VStack(alignment: .leading) {
                    Text("Heart Rate")
                        .font(.headline)
                    HStack {
                        Text(animatedHeartRate.formatted(.number.precision(.fractionLength(0))))
                            .font(.title2)
                            .animation(.easeInOut(duration: 0.5), value: animatedHeartRate) // Smooth animation
                        Image(systemName: "heart.fill")
                            .foregroundColor(heartRateSFSymbolColor(for: healthKitModel.latestHeartRate))
                            .font(.system(size: 24))
                            .accessibilityHidden(true)
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(heartRateCell(for: healthKitModel.latestHeartRate).gradient)
                        .padding(2)
                )
                .accessibilityEnhanced(
                    label: "Heart Rate: \(healthKitModel.latestHeartRate) beats per minute",
                    hint: "Displays the latest heart rate measured using HealthKit"
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
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(variabilityCell(for: healthKitModel.latestHeartRateVariability).gradient)
                        .padding(2)
                )
                .accessibilityEnhanced(
                    label: "HRV: \(healthKitModel.latestHeartRateVariability)",
                    hint: "Displays the latest heart rate Variability measured using HealthKit"
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
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(fitnessCell(for: healthKitModel.latestV02Max).gradient)
                        .padding(2)
                )
                .accessibilityEnhanced(
                    label: "V02 Max: \(healthKitModel.latestV02Max)",
                    hint: "Displays the latest V02 Max measured using HealthKit"
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
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
                        .fill(stepsCell(for: Double(healthKitModel.latestStepCount)).gradient)
                        .padding(2)
                )
                .accessibilityEnhanced(
                    label: "Steps: \(healthKitModel.latestStepCount) steps",
                    hint: "Displays the latest heart rate Variability measured using HealthKit"
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
                }
                .accessibilityEnhanced(
                    label: "Basal Energy: \(healthKitModel.latestRestingEnergy) Cals",
                    hint: "Displays the latest Basal Energy measured using HealthKit"
                )
                .listRowBackground(
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
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
                        .fill(calsCell(for: Double(healthKitModel.latestActiveEnergy)).gradient)
                        .padding(2)
                )
                .accessibilityEnhanced(
                    label: "Active Cals: \(healthKitModel.latestActiveEnergy)",
                    hint: "Displays the latest active cals measured using HealthKit"
                )
    
            } .onReceive(healthKitModel.$latestHeartRate) { newHeartRate in
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.animatedHeartRate = newHeartRate
                }
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
    
    func heartRateCell(for heartRate: Double) -> Color {
        if (heartRate > 100) { return Color.yellow.opacity(0.7) }
        else if (heartRate < 80) { return Color.green.opacity(0.7) }
        else { return Color.blue.opacity(0.7) }
    }
    
    func variabilityCell(for heartRateVariability: Double) -> Color {
        if (heartRateVariability < 20) {
            return Color.red.opacity(0.7)
        } else if (heartRateVariability < 40) {
            return Color.yellow.opacity(0.7)
        } else if (heartRateVariability > 60) {
            return Color.teal.opacity(0.7)
        } else if (heartRateVariability > 85) {
            return Color.green.opacity(0.7)
        } else { return Color.blue.opacity(0.7) }
    }
    
    func fitnessCell(for cardioFitness: Double) -> Color {
        if (cardioFitness >= 50) {
            return Color.blue.opacity(0.7)
        } else if (cardioFitness >= 40) {
            return Color.green.opacity(0.7)
        } else {
            return Color.yellow.opacity(0.7)
        }
        
    }
    
    func stepsCell(for steps: Double) -> Color {
        if (steps > 12500) {
            return Color.blue.opacity(0.7)
        } else if (steps > 9000) {
            return Color.green.opacity(0.7)
        } else if (steps > 5750) {
            return Color.cyan.opacity(0.7)
        } else { return Color.yellow.opacity(0.7) }
    }
    
    func bmrCell(for bmr: Double) -> Color {
        switch bmr {
        case ..<800:
            return Color.yellow.opacity(0.7)
        case 1200..<1500:
            return Color.green.opacity(0.7)
        case 1800..<2000:
            return Color.blue.opacity(0.7)
        default:
            return Color.purple.opacity(0.7)
        }
    }

    func calsCell(for cals: Double) -> Color {
        if (cals > 500) { return Color.blue.opacity(0.7) }
        else if (cals > 399) { return Color.green.opacity(0.7) }
        else { return Color.yellow.opacity(0.7) }
    }
}

#Preview {
    if #available(watchOS 9.0, *) {
        HealthKitPage()
    } else {
        // Fallback on earlier versions
    }
}
