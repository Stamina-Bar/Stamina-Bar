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
    
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        if workoutManager.workout == nil {
            ProgressView("Closing Stamina Bar")
                .navigationBarHidden(true)
        }
        
        // MARK: - Summary if user chooses stamina bar (hides distance)
        else if workoutManager.selectedWorkout == .other || workoutManager.selectedWorkout == .yoga ||  workoutManager.selectedWorkout == .traditionalStrengthTraining {
            ScrollView {
                VStack(alignment: .leading) {
                    // Add time
                    SummaryMetricView(title: "Elapsed Time",
                                      value: durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? "")
                    .foregroundStyle(.white)
                    
                    Text("Avgerage")
                    //StaminaBarView(data: workoutManager.averageHeartRate)
                    (staminaBarView.stressFunction(heart_rate: workoutManager.averageHeartRate) as AnyView)
                    Divider()
                    
                    SummaryMetricView(title: "Avg. Heart Rate",
                                      value: workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                    .foregroundStyle(.red)
                    
                    SummaryMetricView(title: "Cals Burned",
                                      value: Measurement(value: workoutManager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,unit: UnitEnergy.kilocalories)
                        .formatted(.measurement(width: .abbreviated,
                                                usage: .workout,
                                                numberFormatStyle: .number.precision(.fractionLength(0)))))
                    .foregroundStyle(.pink)
                    
                    
                    SummaryMetricView(title: "Total Daily Calories",
                                      value: formattedCalories(workoutManager.basalEnergy + workoutManager.totalDailyEnergy) + " Cals")
                                      .foregroundStyle(Color.orange) // Choose a color that fits your app's design
                    
                    SummaryMetricView(title: "Daily Step Count",
                                      value: workoutManager.dailyStepCount.formatted(.number.precision(.fractionLength(0))))
                    .foregroundStyle(.blue)
                    
                    SummaryMetricView(title: "Heart Rate Variability",
                                      value: workoutManager.heartRateVariability.formatted(.number.precision(.fractionLength(0))))
                    .foregroundStyle(.blue)
                    
                    SummaryMetricView(title: "V02 Max",
                                      value: workoutManager.currentVO2Max.formatted(.number.precision(.fractionLength(1))))
                    .foregroundStyle(.green)


                    Button("Done") {
                        dismiss()
                    }
                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        // MARK: - Summary to include total distance
        else {
            ScrollView {
                VStack(alignment: .leading) {
                    SummaryMetricView(title: "Elapsed Time",
                                      value: durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? "")
                    .foregroundStyle(.white)
                    
                    SummaryMetricView(title: "Total Distance",
                                      value: Measurement(value: workoutManager.workout?.totalDistance?.doubleValue(for: .mile()) ?? 0,
                                                         unit: UnitLength.miles)
                                        .formatted(.measurement(width: .abbreviated,
                                                                usage: .road,
                                                                numberFormatStyle: .number.precision(.fractionLength(2)))))

                    Text("Avgerage")
                    //StaminaBarView(data: workoutManager.averageHeartRate)
                    (staminaBarView.stressFunction(heart_rate: workoutManager.averageHeartRate) as AnyView)
                    Divider()
                    
                    SummaryMetricView(title: "Avg. Heart Rate",
                                      value: workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                    .foregroundStyle(.red)
                    
                    SummaryMetricView(title: "Cals Burned",
                                      value: Measurement(value: workoutManager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,unit: UnitEnergy.kilocalories)
                        .formatted(.measurement(width: .abbreviated,
                                                usage: .workout,
                                                numberFormatStyle: .number.precision(.fractionLength(0)))))
                    .foregroundStyle(.pink)
                    
                    
                    SummaryMetricView(title: "Total Daily Calories",
                                      value: formattedCalories(workoutManager.basalEnergy + workoutManager.totalDailyEnergy) + " Cals")
                    
                                      .foregroundStyle(Color.orange) // Choose a color that fits your app's design
                    
                    SummaryMetricView(title: "Daily Step Count",
                                      value: workoutManager.dailyStepCount.formatted(.number.precision(.fractionLength(0))))
                    .foregroundStyle(.blue)
                    
                    SummaryMetricView(title: "Heart Rate Variability",
                                      value: workoutManager.heartRateVariability.formatted(.number.precision(.fractionLength(0))))
                    .foregroundStyle(.blue)
                    
                    SummaryMetricView(title: "V02 Max",
                                      value: workoutManager.currentVO2Max.formatted(.number.precision(.fractionLength(1))))
                    .foregroundStyle(.green)

                    Button("Done") {
                        dismiss()
                    }
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
        Divider()
    }
}
