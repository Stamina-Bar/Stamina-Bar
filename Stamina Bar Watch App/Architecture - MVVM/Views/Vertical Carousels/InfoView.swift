//
//  InfoView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 4/16/24.
//

import Foundation
import SwiftUI
import HealthKit

struct InfoView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var showElapsedTime = false
    @State private var hasPausedWorkoutOnAppear = false
    @State private var showSwipeInstruction = true
    @State private var blinkOpacity: Double = 1 // Add this line for blinking effect

    @State private var showingSettings = false // State to control settings view presentation

    
    let staminaBarView = StaminaBarView()
    
    var body: some View {
        TimelineView(InfoViewTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(), isPaused: workoutManager.session?.state == .paused)) { context in
            VStack (alignment: .trailing) {

                // Modified section for the blinking effect
                if showSwipeInstruction {
                    Text("Double tap to Start & Pause a workout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .opacity(blinkOpacity) // Use the blinkOpacity for the blinking effect
                        .transition(.move(edge: .trailing))

                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Wait for 7 seconds before starting blinking
                                // Speeding up the blinking by reducing the duration to 0.3 seconds
                                withAnimation(Animation.easeInOut(duration: 0.3).repeatCount(3, autoreverses: true)) {
                                    self.blinkOpacity = 0.5
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Adjusted for faster blinking
                                    self.blinkOpacity = 1 // Reset the opacity to ensure it's fully visible before sliding out
                                    // Slowing down the ease-in-out by increasing the duration to 2 seconds
                                    withAnimation(.easeInOut(duration: 2)) {
                                        self.showSwipeInstruction = false
                                    }
                                }
                            }
                        }


                }
                
                // TODO: Monitor if this fixes timer being shown in bug fix
                if workoutManager.running == true && showSwipeInstruction == false {
                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: true)
                        .foregroundStyle(.white)
                        .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scenePadding()
                }
                
                // Use your existing staminaBarView logic here
                (staminaBarView.stressFunction(heart_rate: workoutManager.heartRate) as AnyView)

            }
            
            .onTapGesture(count: 2, perform: {
                workoutManager.togglePause()
                workoutManager.running ? HapticManager.directionDownHaptic() : HapticManager.successHaptic()

            })
            
            .onLongPressGesture(minimumDuration: 3) {
                workoutManager.endWorkout()
                HapticManager.stopHaptic()
                
            }
                
            
            
            .onAppear {
                if !self.hasPausedWorkoutOnAppear {
                    self.workoutManager.pause()
                    self.hasPausedWorkoutOnAppear = true // Ensure it's a one-time action
                }
            }
            
            
        }
    }
}




struct InfoViewView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView().environmentObject(WorkoutManager())
    }
}

// Workout builder helper
private struct InfoViewTimelineSchedule: TimelineSchedule {
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

