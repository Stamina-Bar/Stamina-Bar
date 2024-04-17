//
//  ControlsView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.

// MARK: - View to pause, resume, and end workouts in MetricsView

import SwiftUI

struct ControlsView: View {
    
    var body: some View {
        if #available(watchOS 9.0, *) {
            HelperControlsView()
                .background(
                    RadialGradient(
                        gradient: Gradient(colors: [.black, .gray]), // Inner color to outer color
                        center: .center, // The center of the gradient
                        startRadius: 0, // Starting radius of the gradient
                        endRadius: 400 // Ending radius where the gradient stops
                    )
            )
        } else {
            HelperControlsView()
        }
        
        
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(WorkoutManager())
    }
}


struct HelperControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
        VStack {
            workoutManager.running ? Text("Pause Workout") : Text("Start Workout")
            
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
                        
                        workoutManager.running ? HapticManager.startHaptic() : HapticManager.stopHaptic()
                        
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
