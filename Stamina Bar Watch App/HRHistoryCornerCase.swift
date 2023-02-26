//
//  HRHistoryCornerCase.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 2/8/23.
//

import SwiftUI

struct HRHistoryCornerCase: View {
    var title: String
    var value: String
    var unit: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .fontWeight(.regular)
                .font(.system(size: 16))
            Text(String(value))
                .fontWeight(.bold)
                .font(.system(size: 18))
                .foregroundColor(.accentColor)
            Text(String(unit))
                .font(.system(size: 8))
                .foregroundColor(.accentColor)
            Spacer()
        }
    }
}
