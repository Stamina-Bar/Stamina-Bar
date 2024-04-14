//
//  SessionPagingView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.

// MARK: - Horizontal swipe gestures between the three main Tabs

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var kre = "hello"
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    // starts page on main view
    @State private var selection: Tab = .metrics

    enum Tab {
        case controls, metrics, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection) {
                       ControlsView().tag(Tab.controls)
                       VerticalCarouselView().tag(Tab.metrics)
                       NowPlayingView().tag(Tab.nowPlaying)
                }
        
        .navigationTitle(workoutManager.running ? " " : "Stamina Bar")

       

        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(selection == .nowPlaying)
        .onChange(of: workoutManager.running) { _ in
            displayMetricsView()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .onChange(of: isLuminanceReduced) { _ in
            displayMetricsView()
        }
    }

    private func displayMetricsView() {
        withAnimation {
            selection = .metrics
        }
    }
}

struct PagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView().environmentObject(WorkoutManager())
    }
}
