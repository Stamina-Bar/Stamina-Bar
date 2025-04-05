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
    @ObservedObject var healthKitModel = HealthKitModel()
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
    
    /// Schedule a local notification to fire twice Per Day at 9am Central and 2:30pm Central
    /// Mock a health filter to customize the notification
    /// healthkitModel.heartRate > 120
    ///     hey you might need to rest
    ///     Complete one minute of mindfulness and check your HRV.

    func scheduleDailyNotifications(healthKitModel: HealthKitModel) {
        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Daily Health Check"
        content.body = generateHealthMessage(for: healthKitModel)
        content.sound = .default
        
        // Group notifications using a thread identifier
        content.threadIdentifier = "DailyHealthCheck"
        
        // 1) Schedule a notification at 9:00 AM (Central)
        var morningComponents = DateComponents()
        morningComponents.hour = 9
        morningComponents.minute = 0
        morningComponents.timeZone = TimeZone(identifier: "America/Chicago")
        
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningComponents, repeats: true)
        let morningRequest = UNNotificationRequest(
            identifier: "morningNotification",
            content: content,
            trigger: morningTrigger
        )
        
        // 2) Schedule a notification at 2:30 PM (Central)
        var afternoonComponents = DateComponents()
        afternoonComponents.hour = 14
        afternoonComponents.minute = 30
        afternoonComponents.timeZone = TimeZone(identifier: "America/Chicago")
        
        let afternoonTrigger = UNCalendarNotificationTrigger(dateMatching: afternoonComponents, repeats: true)
        let afternoonRequest = UNNotificationRequest(
            identifier: "afternoonNotification",
            content: content,
            trigger: afternoonTrigger
        )
        
        // Register both requests
        let center = UNUserNotificationCenter.current()
        center.add(morningRequest) { error in
            if let error = error {
                print("Error scheduling morning notification: \(error.localizedDescription)")
            } else {
                print("Morning notification scheduled for 9:00 AM CT.")
            }
        }
        
        center.add(afternoonRequest) { error in
            if let error = error {
                print("Error scheduling afternoon notification: \(error.localizedDescription)")
            } else {
                print("Afternoon notification scheduled for 2:30 PM CT.")
            }
        }
    }

    /// Generates a custom message based on various HealthKit metrics.
    func generateHealthMessage(for healthKitModel: HealthKitModel) -> String {
        let steps = healthKitModel.latestStepCount
        let hrv = healthKitModel.latestHeartRateVariability
        let activeCalories = healthKitModel.latestActiveEnergy
        
        if hrv > 65 || steps > 7500 || activeCalories > 500 {
            return "Keep up the amazing work."
        } else {
            return "Whether it's a minute of mindfulness or a quick activity, every lifestyle change counts!"
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
