//
//  HeartRateMessageView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 1/30/23.
//

import SwiftUI

struct HeartRateMessageView: View {
    var message: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(message)
                .fontWeight(.regular)
                .font(.system(size: 16))
            Spacer()
        }
    }
}

