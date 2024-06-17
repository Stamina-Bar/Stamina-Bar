//
//  SummaryView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.
//

// MARK: - View to show statistics after a workout is completed

import Foundation
import HealthKit
import SwiftUI
import WatchKit

struct SummaryView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) var dismiss
    let staminaBarView = StaminaBarView()
    @State private var showError = false
    @State private var animateValue = false
    
    
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        
        if workoutManager.workout == nil {
            
            if showError {
                if #available(watchOS 10.0, *) {
                    // Using ScrollView for long error message
                    ScrollView {
                        Image(systemName: "digitalcrown.press.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .symbolEffect(.pulse.byLayer, options: .repeat(10), value: animateValue)
                            .onAppear {
                                animateValue.toggle()
                            }
                        
                        Text("The app is taking longer than expected to generate your workout summary. Please double tap the Digital Crown then swipe away to close the app. Reopen the app afterwards.")
                            .multilineTextAlignment(.center)
                            .padding()
                            .navigationBarHidden(true)
                    }
                } else {
                    ScrollView {
                        Image(systemName: "digitalcrown.press.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                        
                        Text("The app is taking longer than expected to generate your workout summary. Please double tap the Digital Crown then swipe away to close the app. Reopen the app afterwards.")
                            .multilineTextAlignment(.center)
                            .padding()
                            .navigationBarHidden(true)
                    }
                }
                
            } else {
                ProgressView("Generating Summary...")
                    .navigationBarHidden(true)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                            if workoutManager.workout == nil {
                                // Update the state to show error after 30 seconds
                                self.showError = true
                            }
                        }
                    }
            }
            
        }
        
        // MARK: - Summary if user chooses stamina bar (hides distance)
        else {
            ScrollView {
                VStack(alignment: .leading) {
                    // Add time
                    SummaryMetricView(title: "Elapsed Time",
                                      value: durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? "")
                    .foregroundStyle(.white)
                    Divider()
                    
                    Text("Stamina % Average")
                    //StaminaBarView(data: workoutManager.averageHeartRate)
                    (staminaBarView.stressFunction(heart_rate: workoutManager.averageHeartRate) as AnyView)
                    Divider()
                    
                    SummaryMetricView(title: "Daily Calories Burned",
                                      value: formattedCalories(workoutManager.basalEnergy + workoutManager.totalDailyEnergy) + " Cals")
                    .foregroundStyle(Color.orange)
                    Divider()
                    
                    SummaryMetricView(title: "Distance Tracked",
                                      value: workoutManager.distance.formatted(.number.precision(.fractionLength(2))) + " miles")
                    .foregroundStyle(.blue)
                    Divider()
                    
                    SummaryMetricView(title: "HRV",
                                      value: workoutManager.heartRateVariability.formatted(.number.precision(.fractionLength(0))))
                    .foregroundStyle(.blue)
                    Divider()
                    
                    SummaryMetricView(title: "V02 Max",
                                      value: workoutManager.currentVO2Max.formatted(.number.precision(.fractionLength(1))))
                    .foregroundStyle(.green)
                    
                    
                    Button("Done") {
                        dismiss()
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)) 
                        .cornerRadius(25)
                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Helper function to format calories with commas as a whole number
    private func formattedCalories(_ value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0 // Ensures no decimal places
        return numberFormatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
    }
    
    
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}

struct SummaryMetricView: View {
    var title: String
    var value: String
    
    var body: some View {
        Text(title)
            .foregroundStyle(.foreground)
        Text(value)
            .font(.system(.title2, design: .rounded).lowercaseSmallCaps())
    }
}

