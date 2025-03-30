//
//  SimpleInlineTip.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 11/17/24.
//


import Foundation
import TipKit

struct SimpleInlineTip: Tip {
    var title: Text {
        Text("View Health Stats")
    }

    // Text needs to be optional, otherwise it does not show up.
    var message: Text? {
        Text("View your most important health stats at a glance. After runs or walks, check your VO2 Max trends. Monitor HRV for recovery and readiness a higher HRV suggests improved recovery and stress resilience.")
    }

    var image: Image? {
        Image(systemName: "heart.fill")
    }
}
