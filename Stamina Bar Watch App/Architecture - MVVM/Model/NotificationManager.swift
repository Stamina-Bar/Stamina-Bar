//
//  NotificationManager.swift
//  Stamina Bar
//
//  Created by Bryce Ellis on 3/30/25.
//


import SwiftUI
import UserNotifications
import WatchKit

@MainActor
final class NotificationManager: NSObject, WKExtensionDelegate, @preconcurrency UNUserNotificationCenterDelegate {
    // Singleton for reuse.
    static let shared = NotificationManager()
    
    override init() {
        super.init()
        // Set self as the notification center delegate.
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: - Public Methods
    
    /// Request notification permission.
    func requestNotificationPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    /// Schedule a local notification to fire after 5 seconds.
    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hello from watchOS!"
        content.body = "This is a test local notification."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Local notification scheduled.")
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Use .banner (instead of deprecated .alert) along with .sound.
        completionHandler([.banner, .sound])
    }
    
}
