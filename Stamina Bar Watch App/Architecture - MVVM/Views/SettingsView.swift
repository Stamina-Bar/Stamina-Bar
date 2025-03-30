//
//  SettingsView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 12/15/24.
//


//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("hapticsEnabled") var hapticsEnabled: Bool = false
    
    // Accessing app version and build number
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // QR Code Section
                VStack(alignment: .center, spacing: 10) {
                    Image("QR-Code")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Text("Scan with iPhone to see FAQ's")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack(spacing: 15) {
                    // App Information
                    Text("How is Stamina Bar Calculated?")
                        .font(.headline)
                    Text("Stamina Bar is a normalized value of your Heart Rate Variability (HRV), VO2 Max, and Heart Rate. These metrics help assess your recovery and exertion levels.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Divider()
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Sources:")
                            .font(.headline)
                        Text("• Harvard Health – 'Understanding HRV: A New Way to Track Well-Being'")
                        Text("• Mayo Clinic – 'VO2 Max & Endurance Training'")
                        Text("• American Heart Association – 'Heart Rate Zones & Exercise Intensity'")
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                }
                .padding()
                
                Divider()
                
                // App Version Section
                VStack(spacing: 10) {
                    Text("Version: \(appVersion)")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Text("Released Mar. 17")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
}


