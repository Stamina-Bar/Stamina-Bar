//
//  AccessibilityModifier.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 11/15/24.
//


import SwiftUI

struct AccessibilityModifier: ViewModifier {
    let label: String
    let hint: String

    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint)
            .dynamicTypeSize(.large ... .xxLarge) // Supports larger text sizes
    }
}

extension View {
    func accessibilityEnhanced(label: String, hint: String) -> some View {
        self.modifier(AccessibilityModifier(label: label, hint: hint))
    }
}
