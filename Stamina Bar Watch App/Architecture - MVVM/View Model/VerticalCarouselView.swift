//
//  VerticalCarouselView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 6/12/23.
//

import Foundation
import SwiftUI

struct VerticalCarouselView: View {
    @State private var carouselSelection = 0
    @EnvironmentObject var workoutManager: WorkoutManager
    private let setOfColors: [Color] = [.black, .blue, .green, .yellow, .orange]
    
    // Computed property to determine colors based on heart rate
    private var colorsForGradient: [Color] {
        if workoutManager.heartRate < 80 {
            return Array(setOfColors.prefix(2))
        } else if workoutManager.heartRate < 100 {
            return [setOfColors[0], setOfColors[2]]
        } else if workoutManager.heartRate < 130 {
            return [setOfColors[0], setOfColors[3]]
        } else {
            return [setOfColors[0], setOfColors[4]]
        }
    }

    
    var body: some View {
        
        if #available(watchOS 10.0, *) {
            TabView(selection: $carouselSelection) {
                InfoView()
                    .tag(0)
                HeartRateView()
                    .tag(1)
                CurrentCaloriesView()
                    .tag(2)
                TotalCaloriesView()
                    .tag(3)
                StepCountView()
                    .tag(4)
                TotalDistanceView()
                    .tag(5)
                CardioFitnessView()
                    .tag(6)
                HeartRateVariabilityView()
                    .tag(7)
            }
            .tabViewStyle(.carousel)
            .background(
                RadialGradient(
                    gradient: Gradient(colors: colorsForGradient), // Use dynamic colors
                    center: .center,
                    startRadius: 0,
                    endRadius: 400
                )
            )
        }
        
        else {
            TabView(selection: $carouselSelection) {
                InfoView()
                    .tag(0)
                HeartRateView()
                    .tag(1)
                CurrentCaloriesView()
                    .tag(2)
                TotalCaloriesView()
                    .tag(3)
                StepCountView()
                    .tag(4)
                TotalDistanceView()
                    .tag(5)
                CardioFitnessView()
                    .tag(6)
                HeartRateVariabilityView()
                    .tag(7)
            } .tabViewStyle(.carousel)
        }
    }
}
