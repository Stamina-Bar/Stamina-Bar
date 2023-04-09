//
//  SummaryView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.
//

// MARK: - View to show statistics after a workout is completed

import Foundation
import HealthKit
import SwiftUI
import WatchKit

struct SummaryView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) var dismiss
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        // Display relative message once the workout is complete (nil)
        if workoutManager.workout == nil {
            if workoutManager.selectedWorkout == .other {
                ProgressView("Closing Stamina Bar")
                    .navigationBarHidden(true)
            }
            ProgressView("Saving Workout")
                .navigationBarHidden(true)
        }
        
        // MARK: - Summary if user chooses stamina bar (hides distance)
        else if workoutManager.selectedWorkout == .other {
            ScrollView {
                VStack(alignment: .leading) {
                    SummaryMetricView(title: "Total Energy",
                                      value: Measurement(value: workoutManager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                                                         unit: UnitEnergy.kilocalories)
                                        .formatted(.measurement(width: .abbreviated,
                                                                usage: .workout,
                                                                numberFormatStyle: .number.precision(.fractionLength(0)))))
                        .foregroundStyle(.pink)
                    SummaryMetricView(title: "Avg. Heart Rate",
                                      value: workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                        .foregroundStyle(.red)
                    Text("Avg. Stamina")
                    if workoutManager.averageHeartRate < 69 {
                        Image("100")
                    } else if workoutManager.averageHeartRate < 71.3 {
                        Image("99")
                    } else if workoutManager.averageHeartRate < 73.6 {
                        Image("98")
                    } else if workoutManager.averageHeartRate < 75.9 {
                        Image("97")
                    } else if workoutManager.averageHeartRate < 78.2 {
                        Image("96")
                    } else if workoutManager.averageHeartRate < 80.5 {
                        Image("95")
                    } else if workoutManager.averageHeartRate < 82.8 {
                        Image("94")
                    } else if workoutManager.averageHeartRate < 85.1 {
                        Image("93")
                    } else if workoutManager.averageHeartRate < 87.4 {
                        Image("92")
                    } else if workoutManager.averageHeartRate < 89.7 {
                        Image("91")
                    } else if workoutManager.averageHeartRate < 92.0 {
                        Image("90")
                    } else if workoutManager.averageHeartRate < 94.3 {
                        Image("89")
                    } else if workoutManager.averageHeartRate < 96.6 {
                        Image("88")
                    } else if workoutManager.averageHeartRate < 98.9 {
                        Image("87")
                    } else if workoutManager.averageHeartRate < 101.2 {
                        Image("86")
                    } else if workoutManager.averageHeartRate < 103.5 {
                        Image("85")
                    } else if workoutManager.averageHeartRate < 105.8 {
                        Image("84")
                    } else if workoutManager.averageHeartRate < 108.1 {
                        Image("83")
                    } else if workoutManager.averageHeartRate < 110.4 {
                        Image("82")
                    } else if workoutManager.averageHeartRate < 112.7 {
                        Image("81")
                    } else if workoutManager.averageHeartRate < 115.0 {
                        Image("80")
                    } else if workoutManager.averageHeartRate < 117.3 {
                        Image("79")
                    } else if workoutManager.averageHeartRate < 119.6 {
                        Image("78")
                    } else if workoutManager.averageHeartRate < 121.9 {
                        Image("77")
                    } else if workoutManager.averageHeartRate < 124.2 {
                        Image("76")
                    } else if workoutManager.averageHeartRate < 126.5 {
                        Image("75")
                    } else if workoutManager.averageHeartRate < 128.8 {
                        Image("74")
                    } else if workoutManager.averageHeartRate < 131.1 {
                        Image("73")
                    } else if workoutManager.averageHeartRate < 133.4 {
                        Image("72")
                    } else if workoutManager.averageHeartRate < 135.7 {
                        Image("71")
                    } else if workoutManager.averageHeartRate < 138.0 {
                        Image("70")
                    } else if workoutManager.averageHeartRate < 140.3 {
                        Image("69")
                    } else if workoutManager.averageHeartRate < 142.6 {
                        Image("68")
                    } else if workoutManager.averageHeartRate < 144.9 {
                        Image("67")
                    } else if workoutManager.averageHeartRate < 147.2 {
                        Image("66")
                    } else if workoutManager.averageHeartRate < 149.5 {
                        Image("65")
                    } else if workoutManager.averageHeartRate < 151.8 {
                        Image("64")
                    } else if workoutManager.averageHeartRate < 154.1 {
                        Image("63")
                    }
                    else if workoutManager.averageHeartRate < 156.4 {
                        Image("62")
                    } else if workoutManager.averageHeartRate < 157.15 {
                        Image("61")
                    } else if workoutManager.averageHeartRate < 157.9 {
                        Image("60")
                    } else if workoutManager.averageHeartRate < 158.65 {
                        Image("59")
                    } else if workoutManager.averageHeartRate < 159.4 {
                        Image("58")
                    } else if workoutManager.averageHeartRate < 160.15 {
                        Image("57")
                    } else if workoutManager.averageHeartRate < 160.9 {
                        Image("56")
                    } else if workoutManager.averageHeartRate < 161.65 {
                        Image("55")
                    } else if workoutManager.averageHeartRate < 162.4 {
                        Image("54")
                    } else if workoutManager.averageHeartRate < 163.15 {
                        Image("53")
                    } else if workoutManager.averageHeartRate < 163.9 {
                        Image("52")
                    } else if workoutManager.averageHeartRate < 164.65 {
                        Image("51")
                    } else if workoutManager.averageHeartRate < 165.4 {
                        Image("50")
                    } else if workoutManager.averageHeartRate < 166.15 {
                        Image("49")
                    } else if workoutManager.averageHeartRate < 166.9 {
                        Image("48")
                    } else if workoutManager.averageHeartRate < 167.65 {
                        Image("47")
                    } else if workoutManager.averageHeartRate < 168.4 {
                        Image("46")
                    } else if workoutManager.averageHeartRate < 169.15 {
                        Image("45")
                    } else if workoutManager.averageHeartRate < 169.9 {
                        Image("44")
                    } else if workoutManager.averageHeartRate < 170.65 {
                        Image("43")
                    } else if workoutManager.averageHeartRate < 171.4 {
                        Image("42")
                    } else if workoutManager.averageHeartRate < 172.15 {
                        Image("41")
                    } else if workoutManager.averageHeartRate < 172.9 {
                        Image("40")
                    } else if workoutManager.averageHeartRate < 173.65 {
                        Image("39")
                    } else if workoutManager.averageHeartRate < 174.4 {
                        Image("38")
                    } else if workoutManager.averageHeartRate < 175.15 {
                        Image("37")
                    } else if workoutManager.averageHeartRate < 175.9 {
                        Image("36")
                    } else if workoutManager.averageHeartRate < 176.65 {
                        Image("35")
                    } else if workoutManager.averageHeartRate < 177.4 {
                        Image("34")
                    } else if workoutManager.averageHeartRate < 178.15 {
                        Image("33")
                    } else if workoutManager.averageHeartRate < 178.9 {
                        Image("32")
                    } else if workoutManager.averageHeartRate < 179.65 {
                        Image("31")
                    } else if workoutManager.averageHeartRate < 180.4 {
                        Image("30")
                    } else if workoutManager.averageHeartRate < 181.15 {
                        Image("29")
                    } else if workoutManager.averageHeartRate < 181.9 {
                        Image("28")
                    } else if workoutManager.averageHeartRate < 182.65 {
                        Image("27")
                    } else if workoutManager.averageHeartRate < 183.4 {
                        Image("26")
                    } else if workoutManager.averageHeartRate < 184.15 {
                        Image("25")
                    }

                    else if workoutManager.averageHeartRate < 184.9 {
                        Image("24")
                    } else if workoutManager.averageHeartRate < 185.65 {
                        Image("23")
                    } else if workoutManager.averageHeartRate < 186.4 {
                        Image("22")
                    } else if workoutManager.averageHeartRate < 187.15 {
                        Image("21")
                    } else if workoutManager.averageHeartRate < 187.9 {
                        Image("20")
                    } else if workoutManager.averageHeartRate < 188.65 {
                        Image("19")
                    } else if workoutManager.averageHeartRate < 189.4 {
                        Image("18")
                    } else if workoutManager.averageHeartRate < 190.15 {
                        Image("17")
                    } else if workoutManager.averageHeartRate < 190.9 {
                        Image("16")
                    } else if workoutManager.averageHeartRate < 191.65 {
                        Image("15")
                    } else if workoutManager.averageHeartRate < 192.4 {
                        Image("14")
                    } else if workoutManager.averageHeartRate < 193.15 {
                        Image("13")
                    } else if workoutManager.averageHeartRate < 193.9 {
                        Image("12")
                    } else if workoutManager.averageHeartRate < 194.65 {
                        Image("11")
                    } else if workoutManager.averageHeartRate < 195.4 {
                        Image("10")
                    } else if workoutManager.averageHeartRate < 196.15 {
                        Image("9")
                    } else if workoutManager.averageHeartRate < 196.9 {
                        Image("8")
                    } else if workoutManager.averageHeartRate < 197.65 {
                        Image("7")
                    } else if workoutManager.averageHeartRate < 198.4 {
                        Image("6")
                    } else if workoutManager.averageHeartRate < 199.15 {
                        Image("5")
                    } else if workoutManager.averageHeartRate < 199.9 {
                        Image("4")
                    } else if workoutManager.averageHeartRate < 200.65 {
                        Image("3")
                    } else if workoutManager.averageHeartRate < 201.4 {
                        Image("2")
                    } else {
                        Image("1")
                    }

                    Divider()
                    
                    Button("Done") {
                        dismiss()
                    }
                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        // MARK: - Summary to include total distance
        else {
            ScrollView {
                VStack(alignment: .leading) {
                    SummaryMetricView(title: "Total Time",
                                      value: durationFormatter.string(from: workoutManager.workout?.duration ?? 0.0) ?? "")
                        .foregroundStyle(.yellow)
                    
                    SummaryMetricView(title: "Total Energy",
                                      value: Measurement(value: workoutManager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                                                         unit: UnitEnergy.kilocalories)
                                        .formatted(.measurement(width: .abbreviated,
                                                                usage: .workout,
                                                                numberFormatStyle: .number.precision(.fractionLength(0)))))
                        .foregroundStyle(.pink)
                    
                    Text("Avg. Stamina")
                    if workoutManager.averageHeartRate < 69 {
                        Image("100")
                    } else if workoutManager.averageHeartRate < 71.3 {
                        Image("99")
                    } else if workoutManager.averageHeartRate < 73.6 {
                        Image("98")
                    } else if workoutManager.averageHeartRate < 75.9 {
                        Image("97")
                    } else if workoutManager.averageHeartRate < 78.2 {
                        Image("96")
                    } else if workoutManager.averageHeartRate < 80.5 {
                        Image("95")
                    } else if workoutManager.averageHeartRate < 82.8 {
                        Image("94")
                    } else if workoutManager.averageHeartRate < 85.1 {
                        Image("93")
                    } else if workoutManager.averageHeartRate < 87.4 {
                        Image("92")
                    } else if workoutManager.averageHeartRate < 89.7 {
                        Image("91")
                    } else if workoutManager.averageHeartRate < 92.0 {
                        Image("90")
                    } else if workoutManager.averageHeartRate < 94.3 {
                        Image("89")
                    } else if workoutManager.averageHeartRate < 96.6 {
                        Image("88")
                    } else if workoutManager.averageHeartRate < 98.9 {
                        Image("87")
                    } else if workoutManager.averageHeartRate < 101.2 {
                        Image("86")
                    } else if workoutManager.averageHeartRate < 103.5 {
                        Image("85")
                    } else if workoutManager.averageHeartRate < 105.8 {
                        Image("84")
                    } else if workoutManager.averageHeartRate < 108.1 {
                        Image("83")
                    } else if workoutManager.averageHeartRate < 110.4 {
                        Image("82")
                    } else if workoutManager.averageHeartRate < 112.7 {
                        Image("81")
                    } else if workoutManager.averageHeartRate < 115.0 {
                        Image("80")
                    } else if workoutManager.averageHeartRate < 117.3 {
                        Image("79")
                    } else if workoutManager.averageHeartRate < 119.6 {
                        Image("78")
                    } else if workoutManager.averageHeartRate < 121.9 {
                        Image("77")
                    } else if workoutManager.averageHeartRate < 124.2 {
                        Image("76")
                    } else if workoutManager.averageHeartRate < 126.5 {
                        Image("75")
                    } else if workoutManager.averageHeartRate < 128.8 {
                        Image("74")
                    } else if workoutManager.averageHeartRate < 131.1 {
                        Image("73")
                    } else if workoutManager.averageHeartRate < 133.4 {
                        Image("72")
                    } else if workoutManager.averageHeartRate < 135.7 {
                        Image("71")
                    } else if workoutManager.averageHeartRate < 138.0 {
                        Image("70")
                    } else if workoutManager.averageHeartRate < 140.3 {
                        Image("69")
                    } else if workoutManager.averageHeartRate < 142.6 {
                        Image("68")
                    } else if workoutManager.averageHeartRate < 144.9 {
                        Image("67")
                    } else if workoutManager.averageHeartRate < 147.2 {
                        Image("66")
                    } else if workoutManager.averageHeartRate < 149.5 {
                        Image("65")
                    } else if workoutManager.averageHeartRate < 151.8 {
                        Image("64")
                    } else if workoutManager.averageHeartRate < 154.1 {
                        Image("63")
                    }
                    else if workoutManager.averageHeartRate < 156.4 {
                        Image("62")
                    } else if workoutManager.averageHeartRate < 157.15 {
                        Image("61")
                    } else if workoutManager.averageHeartRate < 157.9 {
                        Image("60")
                    } else if workoutManager.averageHeartRate < 158.65 {
                        Image("59")
                    } else if workoutManager.averageHeartRate < 159.4 {
                        Image("58")
                    } else if workoutManager.averageHeartRate < 160.15 {
                        Image("57")
                    } else if workoutManager.averageHeartRate < 160.9 {
                        Image("56")
                    } else if workoutManager.averageHeartRate < 161.65 {
                        Image("55")
                    } else if workoutManager.averageHeartRate < 162.4 {
                        Image("54")
                    } else if workoutManager.averageHeartRate < 163.15 {
                        Image("53")
                    } else if workoutManager.averageHeartRate < 163.9 {
                        Image("52")
                    } else if workoutManager.averageHeartRate < 164.65 {
                        Image("51")
                    } else if workoutManager.averageHeartRate < 165.4 {
                        Image("50")
                    } else if workoutManager.averageHeartRate < 166.15 {
                        Image("49")
                    } else if workoutManager.averageHeartRate < 166.9 {
                        Image("48")
                    } else if workoutManager.averageHeartRate < 167.65 {
                        Image("47")
                    } else if workoutManager.averageHeartRate < 168.4 {
                        Image("46")
                    } else if workoutManager.averageHeartRate < 169.15 {
                        Image("45")
                    } else if workoutManager.averageHeartRate < 169.9 {
                        Image("44")
                    } else if workoutManager.averageHeartRate < 170.65 {
                        Image("43")
                    } else if workoutManager.averageHeartRate < 171.4 {
                        Image("42")
                    } else if workoutManager.averageHeartRate < 172.15 {
                        Image("41")
                    } else if workoutManager.averageHeartRate < 172.9 {
                        Image("40")
                    } else if workoutManager.averageHeartRate < 173.65 {
                        Image("39")
                    } else if workoutManager.averageHeartRate < 174.4 {
                        Image("38")
                    } else if workoutManager.averageHeartRate < 175.15 {
                        Image("37")
                    } else if workoutManager.averageHeartRate < 175.9 {
                        Image("36")
                    } else if workoutManager.averageHeartRate < 176.65 {
                        Image("35")
                    } else if workoutManager.averageHeartRate < 177.4 {
                        Image("34")
                    } else if workoutManager.averageHeartRate < 178.15 {
                        Image("33")
                    } else if workoutManager.averageHeartRate < 178.9 {
                        Image("32")
                    } else if workoutManager.averageHeartRate < 179.65 {
                        Image("31")
                    } else if workoutManager.averageHeartRate < 180.4 {
                        Image("30")
                    } else if workoutManager.averageHeartRate < 181.15 {
                        Image("29")
                    } else if workoutManager.averageHeartRate < 181.9 {
                        Image("28")
                    } else if workoutManager.averageHeartRate < 182.65 {
                        Image("27")
                    } else if workoutManager.averageHeartRate < 183.4 {
                        Image("26")
                    } else if workoutManager.averageHeartRate < 184.15 {
                        Image("25")
                    }

                    else if workoutManager.averageHeartRate < 184.9 {
                        Image("24")
                    } else if workoutManager.averageHeartRate < 185.65 {
                        Image("23")
                    } else if workoutManager.averageHeartRate < 186.4 {
                        Image("22")
                    } else if workoutManager.averageHeartRate < 187.15 {
                        Image("21")
                    } else if workoutManager.averageHeartRate < 187.9 {
                        Image("20")
                    } else if workoutManager.averageHeartRate < 188.65 {
                        Image("19")
                    } else if workoutManager.averageHeartRate < 189.4 {
                        Image("18")
                    } else if workoutManager.averageHeartRate < 190.15 {
                        Image("17")
                    } else if workoutManager.averageHeartRate < 190.9 {
                        Image("16")
                    } else if workoutManager.averageHeartRate < 191.65 {
                        Image("15")
                    } else if workoutManager.averageHeartRate < 192.4 {
                        Image("14")
                    } else if workoutManager.averageHeartRate < 193.15 {
                        Image("13")
                    } else if workoutManager.averageHeartRate < 193.9 {
                        Image("12")
                    } else if workoutManager.averageHeartRate < 194.65 {
                        Image("11")
                    } else if workoutManager.averageHeartRate < 195.4 {
                        Image("10")
                    } else if workoutManager.averageHeartRate < 196.15 {
                        Image("9")
                    } else if workoutManager.averageHeartRate < 196.9 {
                        Image("8")
                    } else if workoutManager.averageHeartRate < 197.65 {
                        Image("7")
                    } else if workoutManager.averageHeartRate < 198.4 {
                        Image("6")
                    } else if workoutManager.averageHeartRate < 199.15 {
                        Image("5")
                    } else if workoutManager.averageHeartRate < 199.9 {
                        Image("4")
                    } else if workoutManager.averageHeartRate < 200.65 {
                        Image("3")
                    } else if workoutManager.averageHeartRate < 201.4 {
                        Image("2")
                    } else {
                        Image("1")
                    }

                    Divider()
                   
                    SummaryMetricView(title: "Total Distance",
                                      value: Measurement(value: workoutManager.workout?.totalDistance?.doubleValue(for: .mile()) ?? 0,
                                                         unit: UnitLength.miles)
                                        .formatted(.measurement(width: .abbreviated,
                                                                usage: .road,
                                                                numberFormatStyle: .number.precision(.fractionLength(2)))))
                        .foregroundStyle(.pink)
                    SummaryMetricView(title: "Avg. Heart Rate",
                                      value: workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                        .foregroundStyle(.red)
                    
                    
//
//                    ActivityRingsView(healthStore: workoutManager.healthStore)
//                        .frame(width: 50, height: 50)
                    Button("Done") {
                        dismiss()
                    }
                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}

struct SummaryMetricView: View {
    var title: String
    var value: String

    var body: some View {
        Text(title)
            .foregroundStyle(.foreground)
        Text(value)
            .font(.system(.title2, design: .rounded).lowercaseSmallCaps())
        Divider()
    }
}

