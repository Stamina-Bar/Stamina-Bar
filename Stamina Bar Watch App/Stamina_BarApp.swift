//
//  Stamina_BarApp.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 11/18/22.

import SwiftUI
import TipKit

@main
struct Stamina_Bar_Watch_AppApp: App {
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
                    .task {
                        try? Tips.configure(
                            [
                                // Reset which tips have been shown and what parameters have been tracked, useful during testing and for this sample project
                                .datastoreLocation(.applicationDefault),
                                
                                // When should the tips be presented? If you use .immediate, they'll all be presented whenever a screen with a tip appears.
                                // You can adjust this on per tip level as well
                                .displayFrequency(.immediate)
                                
                            ]
                        )
                    }
            }
        }
    }
    
    
}
