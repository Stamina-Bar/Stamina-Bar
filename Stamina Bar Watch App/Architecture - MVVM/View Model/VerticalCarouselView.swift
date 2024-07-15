////
////  VerticalCarouselView.swift
////  Stamina Bar Watch App
////
////  Created by Bryce Ellis on 6/12/23.
////
//
//import Foundation
//import SwiftUI
//
//struct VerticalCarouselView: View {
//    @State private var carouselSelection = 0
//    @EnvironmentObject var workoutManager: WorkoutManager
//    
//    var body: some View {
//            TabView(selection: $carouselSelection) {
//                InfoView()
//                    .tag(0)
//                HeartRateView()
//                    .tag(1)
//                TotalDistanceView()
//                    .tag(2)
//                CurrentCaloriesView()
//                    .tag(3)
//                TotalCaloriesView()
//                    .tag(4)
//                HeartRateVariabilityView()
//                    .tag(5)
//                CardioFitnessView()
//                    .tag(6)
//            }
//            .tabViewStyle(.carousel)
//            .navigationBarBackButtonHidden(true)
//    }
//}
