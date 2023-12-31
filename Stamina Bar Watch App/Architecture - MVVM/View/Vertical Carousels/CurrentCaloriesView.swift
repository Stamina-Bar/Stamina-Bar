//
//  DistanceView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 10/7/23.
//  can be heavily refractored


import SwiftUI
import HealthKit

struct CurrentCaloriesView: View {
    // MARK: Data Fields
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.scenePhase) private var scenePhase
    
    let staminaBarView = StaminaBarView()
    
    var body: some View {
        if workoutManager.selectedWorkout == .other {
            TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(), isPaused: workoutManager.session?.state == .paused)) { context in
                VStack (alignment: .trailing) {
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0)
                        .foregroundStyle(.white)
                        .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scenePadding()
                    
                    (staminaBarView.stressFunction(heart_rate: workoutManager.heartRate) as AnyView)
                    HStack {
                        Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                            .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle:
                                    .number.precision(.fractionLength(0)))))
                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        
        else if workoutManager.selectedWorkout == .yoga ||  workoutManager.selectedWorkout == .traditionalStrengthTraining {
            TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(), isPaused: workoutManager.session?.state == .paused)) { context in
                VStack (alignment: .trailing) {
                    // Timer
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0)
                        .foregroundStyle(.white)
                        .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scenePadding()
                    (staminaBarView.stressFunction(heart_rate: workoutManager.heartRate) as AnyView)
                    HStack {
                        Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                            .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle:
                                    .number.precision(.fractionLength(0)))))
                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        
        
        else {
            TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                 isPaused: workoutManager.session?.state == .paused)) { context in
                VStack(alignment: .leading) {
                    // Timer
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0)
                        .foregroundStyle(.white)
                        .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .ignoresSafeArea(edges: .bottom)
                        .scenePadding()
                    (staminaBarView.stressFunction(heart_rate: workoutManager.heartRate) as AnyView)
                    HStack {
                        Spacer()
                        Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                            .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle:
                                    .number.precision(.fractionLength(0)))))
                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                    }
                    
                    // Distance and Proper formatting of it.
                    if workoutManager.distance < 0.5 {
                        Text(Measurement(value: workoutManager.distance, unit: UnitLength.miles).formatted(.measurement(width: .abbreviated, usage: .road, numberFormatStyle: .number.precision(.fractionLength(0)))))
                            .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .ignoresSafeArea(edges: .bottom)
                            .scenePadding()
                    } else {
                        Text(Measurement(value: workoutManager.distance, unit: UnitLength.miles).formatted(.measurement(width: .abbreviated, usage: .road, numberFormatStyle: .number.precision(.fractionLength(2)))))
                            .font(.system(.title3, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .ignoresSafeArea(edges: .bottom)
                            .scenePadding()
                    }
                }
                
            }
        }
    }
}

struct CurrentCaloriesView_Previews: PreviewProvider {
    static var previews: some View {
        // CHANGE
        CurrentCaloriesView().environmentObject(WorkoutManager())
    }
}

// Workout builder helper
private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool
    
    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate,
                                                    by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
    
}

