//
//  HealthKitPage.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 11/15/24.
//

//import SwiftUI
//
//struct HealthKitPage: View {
//    let staminaCalculationAlgorithm = StaminaCalculationAlgorithm()
//    @ObservedObject var healthKitModel = HealthKitModel()
//        
//    var body: some View {
//        
//        VStack(alignment: .leading) {
//            List {
//                VStack (alignment: .leading) {
//                    Text("Steps")
//                        .font(.headline)
//                    HStack {
//                        Text(healthKitModel.latestStepCount.formatted(.number.precision(.fractionLength(0))))
//                            .font(.title2)
//                        Image(systemName: "shoeprints.fill")
//                            .foregroundColor(.mint)
//                            .font(.system(size: 24))
//                    }
//                }
//                .listRowBackground(
//                    RoundedRectangle(cornerRadius: 16)
//                        .fill(.gray.gradient.opacity(0.5))
//                        .padding(2)
//                )
//                .accessibilityEnhanced(
//                    label: "Steps: \(healthKitModel.latestStepCount) steps",
//                    hint: "Displays the latest heart rate Variability measured using HealthKit"
//                )
//                
//                VStack (alignment: .leading) {
//                    Text("Total Cals")
//                        .font(.headline)
//                    HStack {
//                        Text(healthKitModel.totalCalories.formatted(.number.precision(.fractionLength(0))))
//                            .font(.title2)
//                        Image(systemName: "flame.fill")
//                            .foregroundColor(.orange)
//                            .font(.system(size: 24))
//                    }
//                }
//               
//                .listRowBackground(
//                    RoundedRectangle(cornerRadius: 16)
//                        .fill(.gray.gradient.opacity(0.5))
//                        .padding(2)
//                )
//                
//                VStack (alignment: .leading) {
//                    Text("HRV")
//                        .font(.headline)
//                    
//                    HStack {
//                        Text(healthKitModel.latestHeartRateVariability.formatted(.number.precision(.fractionLength(0))))
//                            .font(.title2)
//                        Image(systemName: "waveform.path.ecg")
//                            .foregroundColor(.blue)
//                            .font(.system(size: 24))
//                    }
//                }
//                .listRowBackground(
//                    RoundedRectangle(cornerRadius: 16)
//                        .fill(.gray.gradient.opacity(0.5))
//                        .padding(2)
//                )
//                .accessibilityEnhanced(
//                    label: "HRV: \(healthKitModel.latestHeartRateVariability)",
//                    hint: "Displays the latest heart rate Variability measured using HealthKit"
//                )
//                
//                VStack(alignment: .leading) {
//                    Text("Heart Rate")
//                        .font(.headline)
//                    HStack {
//                        Text(healthKitModel.latestHeartRate.formatted(.number.precision(.fractionLength(0))))
//                            .font(.title2)
//                        Image(systemName: "heart.fill")
//                            .foregroundColor(.red)
//                            .font(.system(size: 24))
//                            .accessibilityHidden(true)
//                    }
//                }
//                .listRowBackground(
//                    RoundedRectangle(cornerRadius: 16)
//                        .fill(.gray.gradient.opacity(0.5))
//                        .padding(2)
//                )
//                .accessibilityEnhanced(
//                    label: "Heart Rate: \(healthKitModel.latestHeartRate) beats per minute",
//                    hint: "Displays the latest heart rate measured using HealthKit"
//                )
//                
//                VStack (alignment: .leading) {
//                    Text("V02 Max")
//                        .font(.headline)
//                    HStack {
//                        // Display latest VO₂ Max value
//                        Text(healthKitModel.latestV02Max.formatted(.number.precision(.fractionLength(1))))
//                            .font(.title2)
//                            .animation(.easeInOut(duration: 0.5), value: healthKitModel.latestV02Max)
//                        
//                        // Lungs icon
//                        Image(systemName: "lungs.fill")
//                            .foregroundColor(.green)
//                            .font(.system(size: 24))
//                        
//                        // Display trend symbol
//                    }
//                }
//                .listRowBackground(
//                    RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
//                        .fill(.gray.gradient.opacity(0.5))
//                        .padding(2)
//                )
//                .accessibilityEnhanced(
//                    label: "V02 Max: \(healthKitModel.latestV02Max) steps",
//                    hint: "Displays the latest V02 Max measured using HealthKit"
//                )
//                
//                VStack(alignment: .leading) {
//                    Text("Respiratory Rate")
//                        .font(.headline)
//                    HStack {
//                        Text(healthKitModel.latestRespiratoryRate.formatted(.number.precision(.fractionLength(1))))
//                            .font(.title2)
//                        Image(systemName: "wind")
//                            .foregroundColor(.teal)
//                            .font(.system(size: 24))
//                            .accessibilityHidden(true)
//                    }
//                }
//                .listRowBackground(
//                    RoundedRectangle(cornerRadius: 16)
//                        .fill(.gray.gradient.opacity(0.5))
//                        .padding(2)
//                )
//                .accessibilityEnhanced(
//                    label: "Heart Rate: \(healthKitModel.latestHeartRate) beats per minute",
//                    hint: "Displays the latest heart rate measured using HealthKit"
//                )
//            } 
//        } .onAppear {
//                healthKitModel.fetchDailyStepCount()
//        }
//    }
//}
//
//#Preview {
//    HealthKitPage()
//    
//}
//
