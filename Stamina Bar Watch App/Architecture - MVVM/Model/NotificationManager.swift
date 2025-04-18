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
final class NotificationManager: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {
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
    
    /// Schedules notifications using default times (9:00 AM and 2:30 PM in Central Time).
    /// This is your original scheduling method.
    func scheduleDailyNotifications(healthKitModel: HealthKitModel) {
        // Create the notification content.
        let content = UNMutableNotificationContent()
        content.title = generateHealthTitle(for: healthKitModel)
        content.body = generateHealthMessage(for: healthKitModel)
        content.sound = .default
        content.threadIdentifier = "DailyHealthCheck"
        
        // Schedule a notification at 9:00 AM (Central Time).
        var morningComponents = DateComponents()
        morningComponents.hour = 9
        morningComponents.minute = 0
        morningComponents.timeZone = TimeZone(identifier: "America/Chicago")
        
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningComponents, repeats: true)
        let morningRequest = UNNotificationRequest(identifier: "morningNotification", content: content, trigger: morningTrigger)
        
        // Schedule a notification at 2:30 PM (Central Time).
        var afternoonComponents = DateComponents()
        afternoonComponents.hour = 14
        afternoonComponents.minute = 30
        afternoonComponents.timeZone = TimeZone(identifier: "America/Chicago")
        
        let afternoonTrigger = UNCalendarNotificationTrigger(dateMatching: afternoonComponents, repeats: true)
        let afternoonRequest = UNNotificationRequest(identifier: "afternoonNotification", content: content, trigger: afternoonTrigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(morningRequest) { error in
            if let error = error {
                print("Error scheduling morning notification: \(error.localizedDescription)")
            }
        }
        center.add(afternoonRequest) { error in
            if let error = error {
                print("Error scheduling afternoon notification: \(error.localizedDescription)")
            }
        }
    }
    
    /// Schedules daily notifications based on custom morning and afternoon times provided by the user.
    /// - Parameters:
    ///   - morningTime: The Date representing the morning notification time.
    ///   - afternoonTime: The Date representing the afternoon notification time.
    func scheduleDailyNotifications(healthKitModel: HealthKitModel ,withMorning morningTime: Date, afternoonTime: Date) {
        let content = UNMutableNotificationContent()
        // Populate the notification content using your health data functions.
        content.title = generateHealthTitle(for: healthKitModel)
        content.body = generateHealthMessage(for: healthKitModel)
        content.sound = .default
        content.threadIdentifier = "DailyHealthCheck"
        
        let calendar = Calendar.current
        
        // Create trigger for the morning notification from the provided Date.
        let morningComponents = calendar.dateComponents([.hour, .minute], from: morningTime)
        var morningTriggerComponents = DateComponents()
        morningTriggerComponents.hour = morningComponents.hour
        morningTriggerComponents.minute = morningComponents.minute
        // Use a desired time zone. Here we use "America/Chicago" to match your original code.
        morningTriggerComponents.timeZone = TimeZone(identifier: "America/Chicago")
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningTriggerComponents, repeats: true)
        let morningRequest = UNNotificationRequest(identifier: "morningNotification", content: content, trigger: morningTrigger)
        
        // Create trigger for the afternoon notification from the provided Date.
        let afternoonComponents = calendar.dateComponents([.hour, .minute], from: afternoonTime)
        var afternoonTriggerComponents = DateComponents()
        afternoonTriggerComponents.hour = afternoonComponents.hour
        afternoonTriggerComponents.minute = afternoonComponents.minute
        afternoonTriggerComponents.timeZone = TimeZone(identifier: "America/Chicago")
        let afternoonTrigger = UNCalendarNotificationTrigger(dateMatching: afternoonTriggerComponents, repeats: true)
        let afternoonRequest = UNNotificationRequest(identifier: "afternoonNotification", content: content, trigger: afternoonTrigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(morningRequest) { error in
            if let error = error {
                print("Error scheduling custom morning notification: \(error.localizedDescription)")
            }
        }
        center.add(afternoonRequest) { error in
            if let error = error {
                print("Error scheduling custom afternoon notification: \(error.localizedDescription)")
            }
        }
    }
    
    /// Cancels any pending daily notifications (both morning and afternoon).
    func cancelDailyNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["morningNotification", "afternoonNotification"])
    }
    
    // MARK: - Health Data Methods
    
    func generateHealthTitle(for healthKitModel: HealthKitModel) -> String {
        let staminaCalculationAlgorithm = StaminaCalculationAlgorithm()
        let (_, staminaPercentage) =
            staminaCalculationAlgorithm.stressFunction(
                heart_rate: healthKitModel.latestHeartRate,
                hrv: healthKitModel.latestHeartRateVariability
            )
        return "Stamina: \(Int(staminaPercentage) ?? 100)%"
    }
    
    func generateHealthMessage(for healthKitModel: HealthKitModel) -> String {
        let steps = healthKitModel.latestStepCount
        let hrv = healthKitModel.latestHeartRateVariability
        let activeCalories = healthKitModel.latestActiveEnergy
        let age = healthKitModel.userAgeInYears
        let vo2Max = healthKitModel.latestV02Max
        let heartRate = healthKitModel.latestHeartRate

        // Handle missing authorization or zero-data case.
        if steps == 0 && hrv == 0 && activeCalories == 0 && heartRate == 0 && vo2Max == 0 {
            return "Health data is not yet available. Make sure Health access is enabled in Settings and try wearing your Apple Watch throughout the day."
        }
        
        let isYoung = age < 30
        let isHealthyVO2 = vo2Max > 45
        let usesStrictBaseline = isYoung && isHealthyVO2
        
        let formattedSteps = NumberFormatter.localizedString(from: NSNumber(value: steps), number: .decimal)
        let formattedCalories = NumberFormatter.localizedString(from: NSNumber(value: Int(activeCalories)), number: .decimal)
        let formattedHRV = String(format: "%.0f", hrv)
        let formattedHR = String(format: "%.0f", heartRate)
        
        // MARK: - HRV (Stress & Recovery)
        let hrvMessage: String
        if usesStrictBaseline {
            switch hrv {
            case 65...:
                hrvMessage = "HRV is \(formattedHRV), indicating strong recovery."
            case 45..<65:
                hrvMessage = "HRV is \(formattedHRV). You're recovering steadily—stay consistent."
            case 35..<45:
                hrvMessage = "HRV is \(formattedHRV), slightly low. Consider a short breathing session to reset."
            default:
                hrvMessage = "HRV is \(formattedHRV), which is low today. A minute of mindfulness may help support recovery."
            }
        } else {
            switch hrv {
            case 60...:
                hrvMessage = "HRV is \(formattedHRV), showing good recovery."
            case 40..<60:
                hrvMessage = "HRV is \(formattedHRV), which is steady but has room to improve."
            case 30..<40:
                hrvMessage = "HRV is \(formattedHRV), slightly low. Try a short mindful moment to help reset."
            default:
                hrvMessage = "HRV is \(formattedHRV), which is low. A calm minute could support recovery."
            }
        }
        
        // MARK: - HR (Heart Awareness)
        let heartRateMessage: String
        if isYoung && heartRate >= 100 {
            heartRateMessage = "Your heart rate is \(formattedHR). If you’re not active, a moment of stillness might help you re-center."
        } else if !isYoung && heartRate >= 95 {
            heartRateMessage = "Current heart rate is \(formattedHR). Be mindful of your pacing if you're at rest."
        } else if heartRate < 60 && hrv < 35 {
            heartRateMessage = "Resting heart rate is \(formattedHR), and recovery is low. Consider gentle breathing or a brief pause."
        } else {
            heartRateMessage = ""
        }
        
        // MARK: - Activity (Steps + Active Calories)
        let activityMessage: String
        switch (steps, activeCalories) {
        case (let s, let c) where s >= 7500 || c >= 500:
            activityMessage = "You’ve logged \(formattedSteps) steps and \(formattedCalories) active calories. Great movement today."
        case (let s, let c) where s >= 4000 || c >= 300:
            activityMessage = "You're staying active with \(formattedSteps) steps and \(formattedCalories) active calories. Keep it going."
        default:
            activityMessage = "So far, you’ve logged \(formattedSteps) steps and \(formattedCalories) active calories. A short walk or light stretch could help."
        }
        
        return [hrvMessage, heartRateMessage, activityMessage]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    // MARK: - UNUserNotificationCenterDelegate Methods
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
