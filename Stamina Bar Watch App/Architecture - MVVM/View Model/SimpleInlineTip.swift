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
        Text("Scroll or Swipe Up on the main page to see all stats.")
    }

    var image: Image? {
        Image(systemName: "heart.fill")
    }
}
