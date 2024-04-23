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
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tab = .verticalCarousel

    enum Tab {
        case verticalCarousel
    }
    
    var body: some View {
        TabView(selection: $selection) {
            VerticalCarouselView().tag(Tab.verticalCarousel)
        }
        //.navigationTitle("Stamina Bar")
        .navigationBarBackButtonHidden(true)
        
        
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
