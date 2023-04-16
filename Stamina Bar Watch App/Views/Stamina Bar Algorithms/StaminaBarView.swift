//
//  StaminaBarView.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 4/18/23.
//

// MARK: For outdoor exercises 

import Foundation
import SwiftUI

class StaminaBarView {
            
        let messages = [
            "Active Recovery & Regeneration",
            "Fat Burn & Aerobic",
            "Anaerobic & Max Effort"
        ]
        
        func visualizeHeartRate(data: CGFloat) -> AnyView {
            let messageIndex: Int
            let imageName: String
            
            switch data {
            case ..<59:
                imageName = "100"
                messageIndex = 0
            case ..<169:
                imageName = "99"
                messageIndex = 1
            default:
                return AnyView(Text("Invalid Value"))
            }
            
            let message = messages[messageIndex]
            
            return AnyView(VStack(alignment: .leading) {
                Image(imageName)
                Text(message)
                    .font(.system(size: 12))
            })
        }
        
    }


