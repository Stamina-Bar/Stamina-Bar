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
            PageView(pageNumber: 0, title: "page1", subTitle: "interesting stuff", imageName: "bell", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 1, title: "page1", subTitle: "interesting stuff", imageName: "bell", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 2, title: "page1", subTitle: "interesting stuff", imageName: "bell", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 3, title: "page1", subTitle: "interesting stuff", imageName: "bell", showsDismissButton: true, shouldShowOnboarding: $shouldShowOnboarding)
            
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
            Image(systemName: imageName)
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
                .padding()
            
            // Law to dissmiss onboarding
            if showsDismissButton {
                Button(action: {
                    shouldShowOnboarding.toggle()
                }, label: {
                    Text("get started")
                        .bold()
                        .foregroundStyle(Color.white)
                        .frame(width: 100, height: 50)
                        .background(Color.green)
                        .cornerRadius(60)
                })
            }
            
        }
        .onAppear {
            if pageNumber == 2 { // Request authorization on the second page
                workoutManager.requestAuthorization()
            }
        }
    }
}

