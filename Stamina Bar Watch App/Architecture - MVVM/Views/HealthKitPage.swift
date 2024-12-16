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
    @State private var animatedSteps: Int = 0
    @State private var animatedBMR: Double = 0
    @State private var animatedActiveCals: Double = 0


    var body: some View {
        
        
        let (staminaView, staminaPercentage) =
        staminaCalculationAlgorithm.stressFunction(
            heart_rate: healthKitModel.latestHeartRate,
            hrv: healthKitModel.latestHeartRateVariability
        )
        
        VStack(alignment: .leading) {
            List {
                VStack (alignment: .leading) {
                    Text("Steps")
                        .font(.headline)
                    HStack {
                        Text(animatedSteps.formatted(.number.precision(.fractionLength(0))))
                            .font(.title2)
                            .animation(.easeInOut(duration: 0.5), value: animatedSteps)
                        Image(systemName: "shoeprints.fill")
                            .foregroundColor(.mint)
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
                    Text("Resting Calories")
                        .font(.headline)
                    HStack {
                        Text(animatedBMR.formatted(.number.precision(.fractionLength(0))))
                            .font(.title2)
                            .animation(.easeInOut(duration: 0.5), value: animatedBMR)
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange.opacity(0.8))
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
                    Text("HRV")
                        .font(.headline)
                    
                    HStack {
                        Text(animatedHRV.formatted(.number.precision(.fractionLength(0))))
                            .font(.title2)
                            .animation(.easeInOut(duration: 0.5), value: animatedHRV)
                        Image(systemName: "waveform.path.ecg")
                            .foregroundColor(.blue)
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
                
                VStack(alignment: .leading) {
                    Text("Heart Rate")
                        .font(.headline)
                    HStack {
                        Text(animatedHeartRate.formatted(.number.precision(.fractionLength(0))))
                            .font(.title2)
                            .animation(.easeInOut(duration: 0.5), value: animatedHeartRate) // Smooth animation
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
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
                    Text("V02 Max")
                        .font(.headline)
                    HStack {
                        // Display latest VO₂ Max value
                        Text(healthKitModel.latestV02Max.formatted(.number.precision(.fractionLength(1))))
                            .font(.title2)
                            .animation(.easeInOut(duration: 0.5), value: healthKitModel.latestV02Max)
                        
                        // Lungs icon
                        Image(systemName: "lungs.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 24))
                        
                        // Display trend symbol
                        Image(systemName: trendSymbol(for: healthKitModel.trend))
                            .foregroundColor(trendColor(for: healthKitModel.trend))
                            .font(.system(size: 20))
                    }
//                    HStack {
//                        Text(animatedV02Max.formatted(.number.precision(.fractionLength(1))))
//                            .font(.title2)
//                            .animation(.easeInOut(duration: 0.5), value: animatedV02Max)
//                        Image(systemName: "lungs.fill")
//                            .foregroundColor(.green)
//                            .font(.system(size: 24))
//                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
                        .fill(stepsCell(for: Double(healthKitModel.latestStepCount)).gradient)
                        .padding(2)
                )
                .accessibilityEnhanced(
                    label: "V02 Max: \(healthKitModel.latestV02Max) steps",
                    hint: "Displays the latest V02 Max measured using HealthKit"
                )
            }
            .onReceive(healthKitModel.$latestHeartRate) { newHeartRate in
                guard newHeartRate > 0 else { return } // Prevent animation for invalid initial values
                if animatedHeartRate != newHeartRate {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.animatedHeartRate = newHeartRate
                    }
                }
            }
            .onReceive(healthKitModel.$latestHeartRateVariability) { newHRV in
                guard newHRV > 0 else { return } // Prevent animation for invalid initial values
                if animatedHRV != newHRV {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.animatedHRV = newHRV
                    }
                }
            }
            .onReceive(healthKitModel.$latestV02Max) { newV02Max in
                guard newV02Max > 0 else { return } // Prevent animation for invalid initial values
                if animatedV02Max != newV02Max {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.animatedV02Max = newV02Max
                    }
                }
            }
            .onReceive(healthKitModel.$latestStepCount) { newStepCount in
                guard newStepCount > 0 else { return } // Prevent animation for invalid initial values
                if animatedSteps != newStepCount {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.animatedSteps = newStepCount
                    }
                }
            }
            .onReceive(healthKitModel.$latestRestingEnergy) { newBMR in
                guard newBMR > 0 else { return } // Prevent animation for invalid initial values
                if animatedBMR != newBMR {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.animatedBMR = newBMR
                    }
                }
            }
            .onReceive(healthKitModel.$latestActiveEnergy) { newActiveEnergy in
                guard newActiveEnergy > 0 else { return } // Prevent animation for invalid initial values
                if animatedActiveCals != newActiveEnergy {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.animatedActiveCals = newActiveEnergy
                    }
                }
            }
            
        }
        
        
    }
    
    func heartRateSFSymbolColor(for heartRate: Double) -> Color {
            return Color.red
    }
    
    func hRVSFSymbolColor(for heartRate: Double) -> Color {
            return Color.green
    }
    
    func heartRateCell(for heartRate: Double) -> Color {
        return Color.gray.opacity(0.5)
    }
    
    func variabilityCell(for heartRateVariability: Double) -> Color {
        return Color.gray.opacity(0.5)
        
    }
    
    func fitnessCell(for cardioFitness: Double) -> Color {
        return Color.gray.opacity(0.5)

    }
    
    func stepsCell(for steps: Double) -> Color {
        return Color.gray.opacity(0.5)

    }
    
    func bmrCell(for bmr: Double) -> Color {
        return Color.gray.opacity(0.5)

    }

    func calsCell(for cals: Double) -> Color {
        return Color.gray.opacity(0.5)
    }
    
     func trendSymbol(
        for trend: HealthKitModel.Trend
    ) -> String {
        switch trend {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .same: return "minus"
        }
    }
    
     func trendColor(
        for trend: HealthKitModel.Trend
    ) -> Color {
        switch trend {
        case .up: return .green
        case .down: return .red
        case .same: return .gray
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

