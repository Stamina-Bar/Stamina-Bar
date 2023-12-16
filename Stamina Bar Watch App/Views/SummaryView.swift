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
        else if workoutManager.selectedWorkout == .other || workoutManager.selectedWorkout == .yoga ||  workoutManager.selectedWorkout == .traditionalStrengthTraining || workoutManager.selectedWorkout == .highIntensityIntervalTraining {
            ScrollView {
                VStack(alignment: .leading) {
                    // Add time
                    SummaryMetricView(title: "Total Time",
                                      value: durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? "")
                    .foregroundStyle(.white)
                    
                    // AVG Stamina
                    Text("Avg. Stamina")
                    //StaminaBarView(data: workoutManager.averageHeartRate)
                    (staminaBarView.stressFunction(heart_rate: workoutManager.averageHeartRate) as AnyView)
                    Divider()
                    SummaryMetricView(title: "Total Energy",
                                      value: Measurement(value: workoutManager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,unit: UnitEnergy.kilocalories)
                        .formatted(.measurement(width: .abbreviated,
                                                usage: .workout,
                                                numberFormatStyle: .number.precision(.fractionLength(0)))))
                    .foregroundStyle(.pink)
                    SummaryMetricView(title: "Avg. Heart Rate",
                                      value: workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                    .foregroundStyle(.red)
                    
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
                    SummaryMetricView(title: "Total Time",
                                      value: durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? "")
                    .foregroundStyle(.white)
                    // AVG Stamina
                    
                    Text("Avg. Stamina")
                    //StaminaBarView(data: workoutManager.averageHeartRate)
                    (staminaBarView.stressFunction(heart_rate: workoutManager.averageHeartRate) as AnyView)
                    Divider()
                    
                    SummaryMetricView(title: "Total Energy",
                                      value: Measurement(value: workoutManager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                                                         unit: UnitEnergy.kilocalories)
                                        .formatted(.measurement(width: .abbreviated,
                                                                usage: .workout,
                                                                numberFormatStyle: .number.precision(.fractionLength(0)))))
                    .foregroundStyle(.pink)
                    
                    
                    
                    SummaryMetricView(title: "Total Distance",
                                      value: Measurement(value: workoutManager.workout?.totalDistance?.doubleValue(for: .mile()) ?? 0,
                                                         unit: UnitLength.miles)
                                        .formatted(.measurement(width: .abbreviated,
                                                                usage: .road,
                                                                numberFormatStyle: .number.precision(.fractionLength(2)))))
                    .foregroundStyle(.pink)
                    SummaryMetricView(title: "Avg. Heart Rate",
                                      value: workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                    .foregroundStyle(.red)
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

