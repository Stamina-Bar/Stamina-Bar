//
//  SessionPagingView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.

// MARK: - Helper View to allow swipe gestures between the three main Tabs

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tab = .verticalCarousel

    enum Tab {
        case controls, verticalCarousel, nowPlaying
    }
    
    var body: some View {
        TabView(selection: $selection) {
                       ControlsView().tag(Tab.controls)
                       VerticalCarouselView().tag(Tab.verticalCarousel)
                       NowPlayingView().tag(Tab.nowPlaying)
                }
        .navigationTitle("Stamina Bar")
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
            selection = .verticalCarousel
        }
    }
}

struct PagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView().environmentObject(WorkoutManager())
    }
}
