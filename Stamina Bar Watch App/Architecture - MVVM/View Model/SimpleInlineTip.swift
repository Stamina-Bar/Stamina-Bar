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
        Text("Show Health Stats")
    }

    // Text needs to be optional, otherwise it does not show up.
    var message: Text? {
        Text("Use the toolbar to show health stats.")
    }

    var image: Image? {
        Image(systemName: "heart.fill")
    }
}
