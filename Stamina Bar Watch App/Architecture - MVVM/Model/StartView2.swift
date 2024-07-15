////
////  StartView2.swift
////  Stamina Bar Watch App
////
////  Created by Bryce Ellis on 7/5/24.
////
//
//import SwiftUI
//
//struct StartView2: View {
//    @EnvironmentObject var workoutManager: WorkoutManager
//    @ObservedObject var healthKitModel = HealthKitModel()
//    let staminaBarView = StaminaBarView()
//    let staminaBarView2 = StaminaBarView2()
//    @State private var selectedTab: Int = 0
//    
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            
//            //            MARK:
//            VStack {
//                Spacer()
//                 
//                staminaBarView2.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//                
//                Spacer()
//                
//                NavigationLink(destination: StartView()) {
//                    Text("Start any Exercise")
//                        .foregroundColor(.blue)  // Change the color to your preference
//                        .underline()             // Add underline if you want it to look like a link
//                        .padding(.vertical, 5)
//                        .padding(.horizontal, 10)
//                }
//                .buttonStyle(PlainButtonStyle())  // This removes the default button styling
//            }
//            .tag(0)
//            //            .containerBackground(colorForHeartRateAndHRV(heartRate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability).gradient, for: .tabView)
//            
//            //            MARK:
//            VStack(alignment: .trailing) {
//                staminaBarView2.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//                HStack {
//                    Text(healthKitModel.latestHeartRate.formatted(.number.precision(.fractionLength(0))) + " BPM")
//                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
//                    Image(systemName: "heart.fill")
//                        .foregroundColor(.red)
//                }
//            }
//            .tag(1)
//            //            .containerBackground(colorForHeartRateAndHRV(heartRate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability).gradient, for: .tabView)
//            
//            //            MARK:
//            VStack(alignment: .trailing) {
//                staminaBarView2.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//                HStack {
//                    Text(healthKitModel.latestHeartRateVariability.formatted(.number.precision(.fractionLength(0))) + " HRV")
//                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
//                    Image(systemName: "waveform.path.ecg")
//                        .foregroundColor(.blue)
//                }
//            }
//            .tag(2)
//            //            .containerBackground(colorForHeartRateAndHRV(heartRate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability).gradient, for: .tabView)
//            
//            //            MARK:
//            VStack(alignment: .trailing) {
//                staminaBarView2.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//                HStack {
//                    Text("\(String(format: "%.1f", healthKitModel.latestV02Max)) VO2 max")
//                        .font(.system(.body, design:
//                                .rounded).monospacedDigit().lowercaseSmallCaps())
//                    
//                    Image(systemName: "lungs.fill")
//                        .foregroundColor(.green)
//                    
//                }
//            }
//            .tag(3)
//            //            .containerBackground(colorForHeartRateAndHRV(heartRate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability).gradient, for: .tabView)
//            
//            //            MARK:
//            VStack(alignment: .trailing) {
//                staminaBarView2.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//                HStack {
//                    Text("\(healthKitModel.latestStepCount) Steps")
//                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
//                    Image(systemName: "shoeprints.fill")
//                        .foregroundColor(.blue)
//                }
//            }
//            .tag(4)
//            //            .containerBackground(colorForHeartRateAndHRV(heartRate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability).gradient, for: .tabView)
//            
//            //            MARK:
//            VStack(alignment: .trailing) {
//                staminaBarView2.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
//                HStack {
//                    Text("\(String(format: "%.0f", healthKitModel.latestRestingEnergy)) Cals")
//                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
//                    Image(systemName: "flame.fill")
//                        .foregroundColor(.orange)
//                }
//            }
//            .tag(5)
//        }
//        .tabViewStyle(.carousel)
//    }
//    
//    
//}
//
//
//#Preview {
//    StartView2()
//}
