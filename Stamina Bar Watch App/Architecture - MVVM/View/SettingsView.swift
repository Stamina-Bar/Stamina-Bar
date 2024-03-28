//
//  SettingsView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/27/24.
//

import Foundation

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Example settings
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false
    @AppStorage("theme") var theme: String = "System"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                    
                    Picker("Theme", selection: $theme) {
                        Text("System").tag("System")
                        Text("Light").tag("Light")
                        Text("Dark").tag("Dark")
                    }
                }
                
                Section {
                    Button("Save Settings") {
                        // Here you can add code to perform when saving settings
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
        }
    }
}
