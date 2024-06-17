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
            
            PageView(pageNumber: 0, title: "Welcome", imageSystemName: "digitalcrown.arrow.clockwise.fill", finalOnboardingPage: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 1, title: "Authorized", imageSystemName: "pip.exit", finalOnboardingPage: true, shouldShowOnboarding: $shouldShowOnboarding)
            
        }
        .tabViewStyle(.carousel)
    }
}

struct PageView: View {
    let pageNumber: Int  
    let title: String
    
    let imageSystemName: String
    let finalOnboardingPage: Bool
    @Binding var shouldShowOnboarding: Bool
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var animateValue = false
    
    var body: some View {
        VStack {
            if !finalOnboardingPage {
                if #available(watchOS 10.0, *) {
                    Image(systemName: imageSystemName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 72, height: 72)
                        .symbolEffect(.pulse.byLayer, options: .repeat(10), value: animateValue)
                        .onAppear {
                            animateValue.toggle()
                        }
                    Text(title)
                        .font(.title)
                } else {
                    Image(systemName: imageSystemName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 72, height: 72)
                    Text(title)
                        .font(.title)
                }
            }
            
            else {
                Image(systemName: imageSystemName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 72, height: 72)
                
                Button(action: {
                    shouldShowOnboarding.toggle()
                }) {
                    Text("Get Started")
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50) // Apply to Button, not Text
                .background(.blue)
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

