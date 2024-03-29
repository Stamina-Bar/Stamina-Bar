//
//  SettingsView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/27/24.
//

import SwiftUI
import Foundation

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Example settings
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false
    @AppStorage("theme") var theme: String = "System"
    
    // Accessing app version and build number
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
    
    var body: some View {
        NavigationView {
            ScrollView {
                Section {
                    VStack(alignment: .center, spacing: 10) {
                        Text("Scan here for FAQ's")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Image("QR-Code") // Make sure this is the name of your QR code image asset
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Spacer()
                Section {
                    HStack {
                        Text("v\(appVersion)")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
