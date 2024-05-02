//
//  ToggleWorkoutTip.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 5/1/24.
//

import Foundation
import SwiftUI
import TipKit



struct ToggleWorkoutTip: Tip {

    var id: String 
    var title: Text {
        Text("Save as a Favorite")
    }
    
    var message: Text {
        Text("Your favorite backyards always appear at the top of the list.")
    }
}

