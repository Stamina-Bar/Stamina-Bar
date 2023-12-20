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

    var body: some View {
        TabView {

            PageView(pageNumber: 0, title: "Welcome!", subTitle: "Scroll Up to Continue", imageName: "SplashLogo", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 1, title: "Authorize", subTitle: "Set Up Health Access", imageName: "HealthAppIcon", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 2, title: "Scan", subTitle: "Learn about the app", imageName: "Frame", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 3, title: "Ready", subTitle: "Complete onboarding", imageName: "SplashLogo", showsDismissButton: true, shouldShowOnboarding: $shouldShowOnboarding)
            
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
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
            
            Text(title)
                .font(.system(size: 24))
            
            Text(subTitle)
                .font(.system(size: 18))
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
                .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)) // Apply to Button
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

