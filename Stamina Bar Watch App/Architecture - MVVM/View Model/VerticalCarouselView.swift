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
    
    var body: some View {
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
            .navigationBarBackButtonHidden(true)

        
    }
}
