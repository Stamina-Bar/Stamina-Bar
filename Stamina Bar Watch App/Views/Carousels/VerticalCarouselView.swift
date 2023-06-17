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
    
    var body: some View {
            TabView(selection: $carouselSelection) {
                MetricsView()
                    .tag(0)
                HealthKitDataView()
                    .tag(1)
                SetStaminaBarGoalView()
                    .tag(2)
            }
            .tabViewStyle(.carousel)
        
    }
}
