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

            PageView(pageNumber: 0, title: "Scroll 🆙", subTitle: "Authorize Health", imageName: "HealthAppIcon", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 1, title: "Welcome", subTitle: "Stamina Bar App", imageName: "SplashLogo", showsDismissButton: true, shouldShowOnboarding: $shouldShowOnboarding)
            
//            PageView(pageNumber: 3, title: "Ready", subTitle: "Complete onboarding", imageName: "SplashLogo", showsDismissButton: true, shouldShowOnboarding: $shouldShowOnboarding)
            
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
            if !showsDismissButton {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 75)
                
                Text(title)
                    .font(.system(size: 24))
                
                Text(subTitle)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 75)
                Text(title)
                    .font(.system(size: 24))
                Text(subTitle)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)
                Button(action: {
                    shouldShowOnboarding.toggle()
                }) {
                    Text("Ready")
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50) // Apply to Button, not Text
                .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)) // Apply to Button
                .cornerRadius(25)
            }
        }
        .onAppear {
            if pageNumber == 1 { // Request authorization on the second page
                workoutManager.requestAuthorization()
            }
        }

    }
}

