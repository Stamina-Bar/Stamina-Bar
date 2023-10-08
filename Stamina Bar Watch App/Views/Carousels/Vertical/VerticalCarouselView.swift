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
                    DistanceView()
                        .tag(1)

                    
            }
            .tabViewStyle(.carousel)
    }
}
