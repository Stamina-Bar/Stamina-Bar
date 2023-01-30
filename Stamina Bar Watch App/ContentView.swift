//
//  ContentView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 11/18/22.
//

import SwiftUI
import HealthKit

// Helper to display values from HealthKit

struct DisplayHeartRateHistory: View {
    @ObservedObject var hkHelper = HealthKitHelper()
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                HeartRateHistoryView(title: "Current heart rate", value: hkHelper.currentHeartRate)
                    .accentColor(.blue)
                HeartRateHistoryView(title: "Max heart rate: ",
                                     value: hkHelper.maxHeartRate)
                    .accentColor(.red)
                HeartRateHistoryView(title: "Min heart rate", value: hkHelper.minHeartRate)
                    .accentColor(.green)
            }
            Spacer()
        }.padding()
    }
}

struct DisplayMessages: View {
    @ObservedObject var hkHelper = HealthKitHelper()
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                if hkHelper.maxHeartRate < 150 {
                    HeartRateMessageView(message: "Your weekly Max HR: \(hkHelper.maxHeartRate) is low for your age. This may affect your Stamina Bar, so going for a walk or doing a HIIT workout will be beneficial to maintaining a healthy heart.")
                }
            }
            Spacer()
        }.padding()
    }
}

struct DisplayStaminaBar: View {
    // MARK: - Wellness/Heart Data fields to manipulate
    let heartRateQuantity = HKUnit(from: "count/min")
    private var healthStore = HKHealthStore()
    @State private var minHeartRate: Int = -1
    @State private var maxHeartRate: Int = 0
    @State private var currentHeartRate = 0
    // MARK: - Stamina Bar simplifies Heart Rate Zones
    var body: some View {
        VStack (alignment: .trailing, spacing: 10) {
            if currentHeartRate == 0 {
                Image("Refresh")
            }
            
            else if currentHeartRate < 65 {Image("100")}
            else if currentHeartRate < 100 {Image("90")}
            else if currentHeartRate < 110 {Image("80")}
            else if currentHeartRate < 130 {Image("75")}
            else if currentHeartRate < 155 {Image("70")}
            else if currentHeartRate < 160 {Image("60")}
            else if currentHeartRate < 165 {Image("50")}
            else if currentHeartRate < 170 {Image("40")}
            else if currentHeartRate < 175 {Image("30")}
            else {Image("20")}
            
            
    // MARK: - UI Elements Under Stamina Bar
            HStack {Button {start()} label: {Image(systemName: "arrow.clockwise")}   .frame(width: 60, height: 40)
                .cornerRadius(5)
                .tint(.mint)
                    Text("\(currentHeartRate) BPM")
                if currentHeartRate == 0 {Image(systemName: "suit.heart.fill")} else {Image(systemName: "suit.heart.fill")
                    .foregroundColor(.red)}}
        }
        .padding()
    }
    
    // MARK: - Set up HealthKit
    func start() {
        autorizeHealthKit()
        startHeartRateQuery(quantityTypeIdentifier: .heartRate)
    }
    
    
    func autorizeHealthKit() {
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        ]
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
    }
    
    private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        // 1
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        // 2
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
            query, samples, deletedObjects, queryAnchor, error in
            // 3
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }
        self.process(samples, type: quantityTypeIdentifier)
        }
        // 4
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        // 5
        healthStore.execute(query)
    }
    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        var lastHeartRate = 0.0
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: heartRateQuantity)
            }
            DispatchQueue.main.async {
                self.currentHeartRate = Int(lastHeartRate)
                if self.maxHeartRate < self.currentHeartRate {
                    self.maxHeartRate = self.currentHeartRate
                }
                if self.minHeartRate == -1 || self.minHeartRate > self.currentHeartRate {
                    self.minHeartRate = self.currentHeartRate
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            DisplayStaminaBar()
            DisplayHeartRateHistory()
            DisplayMessages()
        }
        .tabViewStyle(.page)
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
