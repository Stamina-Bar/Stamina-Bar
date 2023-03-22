//
//  MetricsView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.
//

import SwiftUI
import HealthKit

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var body: some View {
        ScrollView {
            // 1) Show all metrics if user is doing an outdoor workout
            if workoutManager.selectedWorkout == .running || workoutManager.selectedWorkout == .cycling || workoutManager.selectedWorkout == .walking {
                TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                     isPaused: workoutManager.session?.state == .paused)) { context in
                    VStack(alignment: .leading) {
                        ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                            .foregroundStyle(.yellow)
                        Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                            .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                        Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                        Text(Measurement(value: workoutManager.distance, unit: UnitLength.miles).formatted(.measurement(width: .abbreviated, usage: .road, numberFormatStyle: .number.precision(.fractionLength(1)))))
                    }
                    .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .ignoresSafeArea(edges: .bottom)
                    .scenePadding()
                }
            }
            
            // 2) Stamina Bar, calories daily total, and stamina bar
            else if workoutManager.selectedWorkout == .other {
                TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                     isPaused: workoutManager.session?.state == .paused)) { context in
                    VStack(alignment: .trailing) {
                        Spacer(minLength: 50)
                        switch workoutManager.heartRate {
                        case 0...50:
                            Image("100")
                        case 51...60:
                            Image("90")
                        case 61,62:
                            Image("80")
                        case 105...110:
                            Image("40")
                        default:
                            Image("100")
                        }
                        
                        HStack {
                            Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                        
                    }
                    
                }
            }
            
            // Hide distance when user is doing an indoor workout.
            else {
                TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                     isPaused: workoutManager.session?.state == .paused)) { context in
                    VStack(alignment: .leading) {
                        ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                            .foregroundStyle(.yellow)
                        Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                            .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                        Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                    }
                    .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .ignoresSafeArea(edges: .bottom)
                    .scenePadding()
                }
            }
        }
    } // end view
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView().environmentObject(WorkoutManager())
    }
}

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

