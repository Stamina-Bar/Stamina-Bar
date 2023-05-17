//
//  UserAgeReader.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 6/11/23.
//

import HealthKit

class UserAgeReader {
    
    static let healthStore = HKHealthStore()

    static func getUserAge(completion: @escaping (Int?, Error?) -> Swift.Void) {
        // Check if the health data is available
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, NSError(domain: "", code: 100, userInfo: [NSLocalizedDescriptionKey: "Health data is not available"]))
            return
        }

        // Get user's birthday
        do {
            let birthdayComponents = try healthStore.dateOfBirthComponents()
            let calendar = Calendar.current
            let currentDate = Date()
            let currentYear = calendar.component(.year, from: currentDate)
            let currentMonth = calendar.component(.month, from: currentDate)
            let currentDay = calendar.component(.day, from: currentDate)
            
            var age = currentYear - birthdayComponents.year!
            
            // If this year's birthday has not yet come, subtract one year
            if currentMonth < birthdayComponents.month! || (currentMonth == birthdayComponents.month! && currentDay < birthdayComponents.day!) {
                age -= 1
            }
            
            completion(age, nil)
        } catch {
            completion(nil, error)
        }
    }
}
