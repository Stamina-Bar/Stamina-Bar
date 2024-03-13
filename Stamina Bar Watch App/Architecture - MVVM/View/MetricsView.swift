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
    @State private var showElapsedTime = true // Initially show the timer

    let staminaBarView = StaminaBarView()
    
    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(), isPaused: workoutManager.session?.state == .paused)) { context in
            VStack (alignment: .trailing) {
                // The timer is conditionally shown based on `showElapsedTime`
                if showElapsedTime {
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: true)
                        .foregroundStyle(.white)
                        .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scenePadding()
                }
                
                (staminaBarView.stressFunction(heart_rate: workoutManager.heartRate) as AnyView)
                
                HStack {
                    Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " BPM")
                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
            .onAppear {
                // Hide the timer when the view appears
                self.showElapsedTime = false
            }
        }
    }
}


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

