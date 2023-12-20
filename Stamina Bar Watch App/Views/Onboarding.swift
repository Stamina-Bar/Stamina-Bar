//
//  Onboarding.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 12/19/23.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    @State private var currentPageIndex = 0  // State to track the current page

    var body: some View {
        TabView {
            PageView(pageNumber: 0, title: "Welcome", subTitle: "Stamina Bar on Apple Watch", imageName: "SplashLogo", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 1, title: "page1", subTitle: "interesting stuff", imageName: "Frame", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 2, title: "page1", subTitle: "interesting stuff", imageName: "Frame", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 3, title: "page1", subTitle: "interesting stuff", imageName: "Frame", showsDismissButton: true, shouldShowOnboarding: $shouldShowOnboarding)
            
        }
        .tabViewStyle(.carousel)
    }
}

struct PageView: View {
    let pageNumber: Int  // Page number
    let title: String
    let subTitle: String
    let imageName: String
    let showsDismissButton: Bool
    @Binding var shouldShowOnboarding: Bool
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding()
            
            Text(title)
                .font(.system(size: 32))
                .padding()
            
            Text(subTitle)
                .font(.system(size: 24))
                .foregroundStyle(Color.secondary)
                .multilineTextAlignment(.center)
            // Law to dissmiss onboarding
            if showsDismissButton {
                
                Button(action: {
                    shouldShowOnboarding.toggle()
                }) {
                    Text("Get Started")
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50) // Apply to Button, not Text
                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing)) // Apply to Button
                .cornerRadius(25) // Apply to Button
                //.shadow(color: .gray, radius: 5, x: 0, y: 5) // Apply to Button
            }
            
        }
        .onAppear {
            if pageNumber == 2 { // Request authorization on the second page
                workoutManager.requestAuthorization()
            }
        }
    }
}

