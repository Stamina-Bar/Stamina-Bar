//
//  HapticManager.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 5/26/23.
//  This class provides static functions for playing various haptic feedback on an Apple Watch.

import Foundation
import WatchKit

class HapticManager {
    // MARK: Static funcs for different haptic types
    static func clickHaptic() {
        WKInterfaceDevice.current().play(.click)
    }
    
    static func directionDownHaptic() {
        WKInterfaceDevice.current().play(.directionDown)
    }
    
    static func directionUpHaptic() {
        WKInterfaceDevice.current().play(.directionUp)
    }
    
    static func failureHaptic() {
        WKInterfaceDevice.current().play(.failure)
    }
    
    static func navigationGenericManeuverHaptic() {
        WKInterfaceDevice.current().play(.navigationGenericManeuver)
    }
    
    static func navigationLeftTurnHaptic() {
        WKInterfaceDevice.current().play(.navigationLeftTurn)
    }
    
    static func navigationRightTurnHaptic() {
        WKInterfaceDevice.current().play(.navigationRightTurn)
    }
    
    static func notificationHaptic() {
        WKInterfaceDevice.current().play(.notification)
    }
    
    static func retryHaptic() {
        WKInterfaceDevice.current().play(.retry)
    }
    
    static func startHaptic() {
        WKInterfaceDevice.current().play(.start)
    }
    
    static func stopHaptic() {
        WKInterfaceDevice.current().play(.stop)
    }
    
    static func successHaptic() {
        WKInterfaceDevice.current().play(.success)
    }
}
