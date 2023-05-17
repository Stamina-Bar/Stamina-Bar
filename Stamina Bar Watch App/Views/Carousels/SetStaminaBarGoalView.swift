//
//  SetStaminaBarGoalView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 6/12/23.
//

import Foundation
import SwiftUI

struct SetStaminaBarGoalView: View {
    
    @State private var staminaPercentage = 100.0
    @State private var isEditing = false
    
    var body: some View {
        
        VStack {
            Image("\(Int(staminaPercentage))")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onTapGesture {
                    self.isEditing = true
                }
            
            // The label displaying the current stamina percentage
            Text("\(Int(staminaPercentage))%")
            
                .focusable(isEditing)
                .digitalCrownRotation($staminaPercentage, from: 1, through: 100, by: 1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
                .onReceive(NotificationCenter.default.publisher(for: WKExtension.applicationDidBecomeActiveNotification)) { _ in
                    self.isEditing = false
                }
        }
      
    }
}
