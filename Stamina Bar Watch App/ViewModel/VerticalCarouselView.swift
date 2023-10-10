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
            MetricsView()
                .tag(0)
            CurrentCaloriesView()
                .tag(1)
            TotalCaloriesView()
                .tag(2)
            StepCountView()
                .tag(3)
            CardioFitnessView()
                .tag(4)
            HeartRateVariabilityView()
                .tag(5)
            } .tabViewStyle(.carousel)
    }
}
