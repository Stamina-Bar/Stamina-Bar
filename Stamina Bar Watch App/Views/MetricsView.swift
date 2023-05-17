//
//  MetricsView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.
//

import SwiftUI
import HealthKit

struct MetricsView: View {
    // MARK: Data Fields
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.scenePhase) private var scenePhase
    
    let staminaBarView = StaminaBarView()
    
    
    var body: some View {
            // MARK: Stamina Bar selected
            if workoutManager.selectedWorkout == .other {
                TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                     isPaused: workoutManager.session?.state == .paused)) { context in
                        // Stamina Bar and Heart Rate
                        VStack (alignment: .trailing) {
                            (staminaBarView.visualizeHeartRate(data: workoutManager.heartRate) as AnyView)
                            HStack {
                                Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " BPM")
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    
                    .onChange(of: scenePhase) { newScenePhase in
                        switch newScenePhase {
                        case .background:
                            workoutManager.togglePause()
                            HapticManager.failureHaptic()
                            // pauseworkout
                        case .inactive:
                            workoutManager.togglePause()
                        case .active:
                            print("App is active!")
                        @unknown default:
                            print("Unknown")
                        }
                    }
                }
            } // end stamina bar selected
            
            // MARK: Indoor workout selected
            else {
                TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                     isPaused: workoutManager.session?.state == .paused)) { context in
                    VStack(alignment: .leading) {
                        // Timer
                        ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                            .foregroundStyle(.yellow)
                            .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                                           .frame(maxWidth: .infinity, alignment: .leading)
                                           .ignoresSafeArea(edges: .bottom)
                                           
                                           .scenePadding()
                        // Active Energy
                        Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                            .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle:
                                    .number.precision(.fractionLength(0)))))
                        .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                                       .frame(maxWidth: .infinity, alignment: .leading)
                                       .ignoresSafeArea(edges: .bottom)
                                       .scenePadding()
                        // Stamina Bar
                        (staminaBarView.visualizeHeartRate(data: workoutManager.heartRate) as AnyView)

                        // Distance
                        
                        if workoutManager.distance < 1000 {
                            Text(Measurement(value: workoutManager.distance, unit: UnitLength.miles).formatted(.measurement(width: .abbreviated, usage: .road, numberFormatStyle: .number.precision(.fractionLength(0)))))
                                .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .ignoresSafeArea(edges: .bottom)
                                .scenePadding()
                        }
                        
                        else {
                            Text(Measurement(value: workoutManager.distance, unit: UnitLength.miles).formatted(.measurement(width: .abbreviated, usage: .road, numberFormatStyle: .number.precision(.fractionLength(2)))))
                                .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                                                 .frame(maxWidth: .infinity, alignment: .leading)
                                                 .ignoresSafeArea(edges: .bottom)
                                                 .scenePadding()
                        }
                    }
                    
                }
            }
        
        
    }
    
    // Default code
    struct MetricsView_Previews: PreviewProvider {
        static var previews: some View {
            MetricsView().environmentObject(WorkoutManager())
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
    
}
