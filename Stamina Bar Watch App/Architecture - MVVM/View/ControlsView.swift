//
//  ControlsView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.

// MARK: - View to pause, resume, and end workouts in MetricsView

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack {
            Text("On the Move?")
            Spacer()
            HStack {
                VStack {
                    Button {
                        workoutManager.endWorkout()
                        HapticManager.stopHaptic()
                        
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(.red)
                    .font(.title2)
                    Text("End")
                }
                VStack {
                    Button {
                        workoutManager.togglePause()
                        
                        workoutManager.running ? HapticManager.stopHaptic() : HapticManager.startHaptic()
                        
                    } label: {
                        Image(systemName: workoutManager.running ? "pause" : "play")
                    }
                    .tint(.yellow)
                    .font(.title2)
                    Text(workoutManager.running ? "Pause" : "Resume")
                }
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(WorkoutManager())
    }
}
