//
//  MetricsView.swift
//  Stamina Bar Watch App
//
//  Created by Bryce Ellis on 3/17/23.
//

import SwiftUI
import HealthKit

struct MetricsView: View {
    let legacyHealthStore = HKHealthStore()
    @State private var legacyActiveEnergy: Double = 0.0
    @State private var legacyRestingEnergy: Double = 0.0
    
    var totalEnergy: Double {
        return legacyActiveEnergy + legacyRestingEnergy
    }
    
    @EnvironmentObject var workoutManager: WorkoutManager
    var body: some View {
        ScrollView {
            // MARK: Show all metrics if user is doing an outdoor workout
            if workoutManager.selectedWorkout == .running || workoutManager.selectedWorkout == .cycling || workoutManager.selectedWorkout == .walking {
                
                TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                     isPaused: workoutManager.session?.state == .paused)) { context in
                    // Stamina Bar Algorithm
                    VStack(alignment: .leading) {
                        ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                            .foregroundStyle(.yellow)
                        
                        Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                            .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))

                        // MARK: - Displays Green to Yellow, which are great zones

                        if workoutManager.heartRate < 69 {
                            Image("100")
                        } else if workoutManager.heartRate < 71.3 {
                            Image("99")
                        } else if workoutManager.heartRate < 73.6 {
                            Image("98")
                        } else if workoutManager.heartRate < 75.9 {
                            Image("97")
                        } else if workoutManager.heartRate < 78.2 {
                            Image("96")
                        } else if workoutManager.heartRate < 80.5 {
                            Image("95")
                        } else if workoutManager.heartRate < 82.8 {
                            Image("94")
                        } else if workoutManager.heartRate < 85.1 {
                            Image("93")
                        } else if workoutManager.heartRate < 87.4 {
                            Image("92")
                        } else if workoutManager.heartRate < 89.7 {
                            Image("91")
                        } else if workoutManager.heartRate < 92.0 {
                            Image("90")
                        } else if workoutManager.heartRate < 94.3 {
                            Image("89")
                        } else if workoutManager.heartRate < 96.6 {
                            Image("88")
                        } else if workoutManager.heartRate < 98.9 {
                            Image("87")
                        } else if workoutManager.heartRate < 101.2 {
                            Image("86")
                        } else if workoutManager.heartRate < 103.5 {
                            Image("85")
                        } else if workoutManager.heartRate < 105.8 {
                            Image("84")
                        } else if workoutManager.heartRate < 108.1 {
                            Image("83")
                        } else if workoutManager.heartRate < 110.4 {
                            Image("82")
                        } else if workoutManager.heartRate < 112.7 {
                            Image("81")
                        } else if workoutManager.heartRate < 115.0 {
                            Image("80")
                        } else if workoutManager.heartRate < 117.3 {
                            Image("79")
                        } else if workoutManager.heartRate < 119.6 {
                            Image("78")
                        } else if workoutManager.heartRate < 121.9 {
                            Image("77")
                        } else if workoutManager.heartRate < 124.2 {
                            Image("76")
                        } else if workoutManager.heartRate < 126.5 {
                            Image("75")
                        } else if workoutManager.heartRate < 128.8 {
                            Image("74")
                        } else if workoutManager.heartRate < 131.1 {
                            Image("73")
                        } else if workoutManager.heartRate < 133.4 {
                            Image("72")
                        } else if workoutManager.heartRate < 135.7 {
                            Image("71")
                        } else if workoutManager.heartRate < 138.0 {
                            Image("70")
                        } else if workoutManager.heartRate < 140.3 {
                            Image("69")
                        } else if workoutManager.heartRate < 142.6 {
                            Image("68")
                        } else if workoutManager.heartRate < 144.9 {
                            Image("67")
                        } else if workoutManager.heartRate < 147.2 {
                            Image("66")
                        } else if workoutManager.heartRate < 149.5 {
                            Image("65")
                        } else if workoutManager.heartRate < 151.8 {
                            Image("64")
                        } else if workoutManager.heartRate < 154.1 {
                            Image("63")
                        }
                        // MARK: - Orange Zone is a sign of something for sure.
                        else if workoutManager.heartRate < 156.4 {
                            Image("62")
                        } else if workoutManager.heartRate < 157.15 {
                            Image("61")
                        } else if workoutManager.heartRate < 157.9 {
                            Image("60")
                        } else if workoutManager.heartRate < 158.65 {
                            Image("59")
                        } else if workoutManager.heartRate < 159.4 {
                            Image("58")
                        } else if workoutManager.heartRate < 160.15 {
                            Image("57")
                        } else if workoutManager.heartRate < 160.9 {
                            Image("56")
                        } else if workoutManager.heartRate < 161.65 {
                            Image("55")
                        } else if workoutManager.heartRate < 162.4 {
                            Image("54")
                        } else if workoutManager.heartRate < 163.15 {
                            Image("53")
                        } else if workoutManager.heartRate < 163.9 {
                            Image("52")
                        } else if workoutManager.heartRate < 164.65 {
                            Image("51")
                        } else if workoutManager.heartRate < 165.4 {
                            Image("50")
                        } else if workoutManager.heartRate < 166.15 {
                            Image("49")
                        } else if workoutManager.heartRate < 166.9 {
                            Image("48")
                        } else if workoutManager.heartRate < 167.65 {
                            Image("47")
                        } else if workoutManager.heartRate < 168.4 {
                            Image("46")
                        } else if workoutManager.heartRate < 169.15 {
                            Image("45")
                        } else if workoutManager.heartRate < 169.9 {
                            Image("44")
                        } else if workoutManager.heartRate < 170.65 {
                            Image("43")
                        } else if workoutManager.heartRate < 171.4 {
                            Image("42")
                        } else if workoutManager.heartRate < 172.15 {
                            Image("41")
                        } else if workoutManager.heartRate < 172.9 {
                            Image("40")
                        } else if workoutManager.heartRate < 173.65 {
                            Image("39")
                        } else if workoutManager.heartRate < 174.4 {
                            Image("38")
                        } else if workoutManager.heartRate < 175.15 {
                            Image("37")
                        } else if workoutManager.heartRate < 175.9 {
                            Image("36")
                        } else if workoutManager.heartRate < 176.65 {
                            Image("35")
                        } else if workoutManager.heartRate < 177.4 {
                            Image("34")
                        } else if workoutManager.heartRate < 178.15 {
                            Image("33")
                        } else if workoutManager.heartRate < 178.9 {
                            Image("32")
                        } else if workoutManager.heartRate < 179.65 {
                            Image("31")
                        } else if workoutManager.heartRate < 180.4 {
                            Image("30")
                        } else if workoutManager.heartRate < 181.15 {
                            Image("29")
                        } else if workoutManager.heartRate < 181.9 {
                            Image("28")
                        } else if workoutManager.heartRate < 182.65 {
                            Image("27")
                        } else if workoutManager.heartRate < 183.4 {
                            Image("26")
                        } else if workoutManager.heartRate < 184.15 {
                            Image("25")
                        }
                        
                        // MARK: - Red Zone are signs of high stress.
                        else if workoutManager.heartRate < 184.9 {
                            Image("24")
                        } else if workoutManager.heartRate < 185.65 {
                            Image("23")
                        } else if workoutManager.heartRate < 186.4 {
                            Image("22")
                        } else if workoutManager.heartRate < 187.15 {
                            Image("21")
                        } else if workoutManager.heartRate < 187.9 {
                            Image("20")
                        } else if workoutManager.heartRate < 188.65 {
                            Image("19")
                        } else if workoutManager.heartRate < 189.4 {
                            Image("18")
                        } else if workoutManager.heartRate < 190.15 {
                            Image("17")
                        } else if workoutManager.heartRate < 190.9 {
                            Image("16")
                        } else if workoutManager.heartRate < 191.65 {
                            Image("15")
                        } else if workoutManager.heartRate < 192.4 {
                            Image("14")
                        } else if workoutManager.heartRate < 193.15 {
                            Image("13")
                        } else if workoutManager.heartRate < 193.9 {
                            Image("12")
                        } else if workoutManager.heartRate < 194.65 {
                            Image("11")
                        } else if workoutManager.heartRate < 195.4 {
                            Image("10")
                        } else if workoutManager.heartRate < 196.15 {
                            Image("9")
                        } else if workoutManager.heartRate < 196.9 {
                            Image("8")
                        } else if workoutManager.heartRate < 197.65 {
                            Image("7")
                        } else if workoutManager.heartRate < 198.4 {
                            Image("6")
                        } else if workoutManager.heartRate < 199.15 {
                            Image("5")
                        } else if workoutManager.heartRate < 199.9 {
                            Image("4")
                        } else if workoutManager.heartRate < 200.65 {
                            Image("3")
                        } else if workoutManager.heartRate < 201.4 {
                            Image("2")
                        } else {
                            Image("1")
                        }
                        
                        Text(Measurement(value: workoutManager.distance, unit: UnitLength.miles).formatted(.measurement(width: .abbreviated, usage: .road, numberFormatStyle: .number.precision(.fractionLength(2)))))
                    }
                   
                    .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .ignoresSafeArea(edges: .bottom)
                    .scenePadding()
                }
            }
            // MARK: Show Stamina Bar, active + resting calories, and HR BPM + its ranges
            else if workoutManager.selectedWorkout == .other {
                TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                     isPaused: workoutManager.session?.state == .paused)) { context in
                    // MARK: Stamina Bar Algorithm
                    VStack(alignment: .trailing) {
                        Spacer(minLength: 50)
                        
                        Text("\(totalEnergy, specifier: "%.0f") kcal")
//                            .font(.largeTitle)
                        
                        if workoutManager.heartRate < 65 {
                            Image("100")
                        } else if workoutManager.heartRate < 67 {
                            Image("99")
                        } else if workoutManager.heartRate < 69 {
                            Image("98")
                        } else if workoutManager.heartRate < 71 {
                            Image("97")
                        } else if workoutManager.heartRate < 73 {
                            Image("96")
                        } else if workoutManager.heartRate < 74 {
                            Image("95")
                        } else if workoutManager.heartRate < 75 {
                            Image("94")
                        } else if workoutManager.heartRate < 77 {
                            Image("93")
                        } else if workoutManager.heartRate < 79 {
                            Image("92")
                        } else if workoutManager.heartRate < 80 {
                            Image("91")
                        } else if workoutManager.heartRate < 81 {
                            Image("90")
                        } else if workoutManager.heartRate < 82 {
                            Image("89")
                        } else if workoutManager.heartRate < 83 {
                            Image("88")
                        } else if workoutManager.heartRate < 84 {
                            Image("87")
                        } else if workoutManager.heartRate < 85 {
                            Image("86")
                        } else if workoutManager.heartRate < 86 {
                            Image("85")
                        } else if workoutManager.heartRate < 87 {
                            Image("84")
                        } else if workoutManager.heartRate < 88 {
                            Image("83")
                        } else if workoutManager.heartRate < 89 {
                            Image("82")
                            // Image to relax.
                        } else if workoutManager.heartRate < 112 {
                            Image("81")
                        } else if workoutManager.heartRate < 115.0 {
                            Image("80")
                        } else if workoutManager.heartRate < 117.3 {
                            Image("79")
                        } else if workoutManager.heartRate < 119.6 {
                            Image("78")
                        } else if workoutManager.heartRate < 121.9 {
                            Image("77")
                        } else if workoutManager.heartRate < 124.2 {
                            Image("76")
                        } else if workoutManager.heartRate < 126.5 {
                            Image("75")
                        } else if workoutManager.heartRate < 128.8 {
                            Image("74")
                        } else if workoutManager.heartRate < 131.1 {
                            Image("73")
                        } else if workoutManager.heartRate < 133.4 {
                            Image("72")
                        } else if workoutManager.heartRate < 135.7 {
                            Image("71")
                        } else if workoutManager.heartRate < 138.0 {
                            Image("70")
                        } else if workoutManager.heartRate < 140.3 {
                            Image("69")
                        } else if workoutManager.heartRate < 142.6 {
                            Image("68")
                        } else if workoutManager.heartRate < 144.9 {
                            Image("67")
                        } else if workoutManager.heartRate < 147.2 {
                            Image("66")
                        } else if workoutManager.heartRate < 149.5 {
                            Image("65")
                        } else if workoutManager.heartRate < 151.8 {
                            Image("64")
                        } else if workoutManager.heartRate < 154.1 {
                            Image("63")
                        }
                        else if workoutManager.heartRate < 156.4 {
                            Image("62")
                        } else if workoutManager.heartRate < 157.15 {
                            Image("61")
                        } else if workoutManager.heartRate < 157.9 {
                            Image("60")
                        } else if workoutManager.heartRate < 158.65 {
                            Image("59")
                        } else if workoutManager.heartRate < 159.4 {
                            Image("58")
                        } else if workoutManager.heartRate < 160.15 {
                            Image("57")
                        } else if workoutManager.heartRate < 160.9 {
                            Image("56")
                        } else if workoutManager.heartRate < 161.65 {
                            Image("55")
                        } else if workoutManager.heartRate < 162.4 {
                            Image("54")
                        } else if workoutManager.heartRate < 163.15 {
                            Image("53")
                        } else if workoutManager.heartRate < 163.9 {
                            Image("52")
                        } else if workoutManager.heartRate < 164.65 {
                            Image("51")
                        } else if workoutManager.heartRate < 165.4 {
                            Image("50")
                        } else if workoutManager.heartRate < 166.15 {
                            Image("49")
                        } else if workoutManager.heartRate < 166.9 {
                            Image("48")
                        } else if workoutManager.heartRate < 167.65 {
                            Image("47")
                        } else if workoutManager.heartRate < 168.4 {
                            Image("46")
                        } else if workoutManager.heartRate < 169.15 {
                            Image("45")
                        } else if workoutManager.heartRate < 169.9 {
                            Image("44")
                        } else if workoutManager.heartRate < 170.65 {
                            Image("43")
                        } else if workoutManager.heartRate < 171.4 {
                            Image("42")
                        } else if workoutManager.heartRate < 172.15 {
                            Image("41")
                        } else if workoutManager.heartRate < 172.9 {
                            Image("40")
                        } else if workoutManager.heartRate < 173.65 {
                            Image("39")
                        } else if workoutManager.heartRate < 174.4 {
                            Image("38")
                        } else if workoutManager.heartRate < 175.15 {
                            Image("37")
                        } else if workoutManager.heartRate < 175.9 {
                            Image("36")
                        } else if workoutManager.heartRate < 176.65 {
                            Image("35")
                        } else if workoutManager.heartRate < 177.4 {
                            Image("34")
                        } else if workoutManager.heartRate < 178.15 {
                            Image("33")
                        } else if workoutManager.heartRate < 178.9 {
                            Image("32")
                        } else if workoutManager.heartRate < 179.65 {
                            Image("31")
                        } else if workoutManager.heartRate < 180.4 {
                            Image("30")
                        } else if workoutManager.heartRate < 181.15 {
                            Image("29")
                        } else if workoutManager.heartRate < 181.9 {
                            Image("28")
                        } else if workoutManager.heartRate < 182.65 {
                            Image("27")
                        } else if workoutManager.heartRate < 183.4 {
                            Image("26")
                        } else if workoutManager.heartRate < 184.15 {
                            Image("25")
                        }
                        else if workoutManager.heartRate < 184.9 {
                            Image("24")
                        } else if workoutManager.heartRate < 185.65 {
                            Image("23")
                        } else if workoutManager.heartRate < 186.4 {
                            Image("22")
                        } else if workoutManager.heartRate < 187.15 {
                            Image("21")
                        } else if workoutManager.heartRate < 187.9 {
                            Image("20")
                        } else if workoutManager.heartRate < 188.65 {
                            Image("19")
                        } else if workoutManager.heartRate < 189.4 {
                            Image("18")
                        } else if workoutManager.heartRate < 190.15 {
                            Image("17")
                        } else if workoutManager.heartRate < 190.9 {
                            Image("16")
                        } else if workoutManager.heartRate < 191.65 {
                            Image("15")
                        } else if workoutManager.heartRate < 192.4 {
                            Image("14")
                        } else if workoutManager.heartRate < 193.15 {
                            Image("13")
                        } else if workoutManager.heartRate < 193.9 {
                            Image("12")
                        } else if workoutManager.heartRate < 194.65 {
                            Image("11")
                        } else if workoutManager.heartRate < 195.4 {
                            Image("10")
                        } else if workoutManager.heartRate < 196.15 {
                            Image("9")
                        } else if workoutManager.heartRate < 196.9 {
                            Image("8")
                        } else if workoutManager.heartRate < 197.65 {
                            Image("7")
                        } else if workoutManager.heartRate < 198.4 {
                            Image("6")
                        } else if workoutManager.heartRate < 199.15 {
                            Image("5")
                        } else if workoutManager.heartRate < 199.9 {
                            Image("4")
                        } else if workoutManager.heartRate < 200.65 {
                            Image("3")
                        } else if workoutManager.heartRate < 201.4 {
                            Image("2")
                        } else {
                            Image("1")
                        }

                        HStack {
                            Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                        
                    }
                    .onAppear() {
                        authorizeLegacyHealthKit()
                        startLegacyActiveEnergyQuery()
                        startLegacyRestingEnergyQuery()
                    }
                    
                }
            }
            
            // Hide distance when user is doing an indoor workout.
            else {
                TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                     isPaused: workoutManager.session?.state == .paused)) { context in
                    // MARK: Stamina Bar Algorithm
                    VStack(alignment: .leading) {
                        ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0, showSubseconds: context.cadence == .live)
                            .foregroundStyle(.yellow)
                        Text(Measurement(value: workoutManager.activeEnergy, unit: UnitEnergy.kilocalories)
                            .formatted(.measurement(width: .abbreviated, usage: .workout, numberFormatStyle: .number.precision(.fractionLength(0)))))
                        
                      

                        if workoutManager.heartRate < 69 {
                            Image("100")
                        } else if workoutManager.heartRate < 71.3 {
                            Image("99")
                        } else if workoutManager.heartRate < 73.6 {
                            Image("98")
                        } else if workoutManager.heartRate < 75.9 {
                            Image("97")
                        } else if workoutManager.heartRate < 78.2 {
                            Image("96")
                        } else if workoutManager.heartRate < 80.5 {
                            Image("95")
                        } else if workoutManager.heartRate < 82.8 {
                            Image("94")
                        } else if workoutManager.heartRate < 85.1 {
                            Image("93")
                        } else if workoutManager.heartRate < 87.4 {
                            Image("92")
                        } else if workoutManager.heartRate < 89.7 {
                            Image("91")
                        } else if workoutManager.heartRate < 92.0 {
                            Image("90")
                        } else if workoutManager.heartRate < 94.3 {
                            Image("89")
                        } else if workoutManager.heartRate < 96.6 {
                            Image("88")
                        } else if workoutManager.heartRate < 98.9 {
                            Image("87")
                        } else if workoutManager.heartRate < 101.2 {
                            Image("86")
                        } else if workoutManager.heartRate < 103.5 {
                            Image("85")
                        } else if workoutManager.heartRate < 105.8 {
                            Image("84")
                        } else if workoutManager.heartRate < 108.1 {
                            Image("83")
                        } else if workoutManager.heartRate < 110.4 {
                            Image("82")
                        } else if workoutManager.heartRate < 112.7 {
                            Image("81")
                        } else if workoutManager.heartRate < 115.0 {
                            Image("80")
                        } else if workoutManager.heartRate < 117.3 {
                            Image("79")
                        } else if workoutManager.heartRate < 119.6 {
                            Image("78")
                        } else if workoutManager.heartRate < 121.9 {
                            Image("77")
                        } else if workoutManager.heartRate < 124.2 {
                            Image("76")
                        } else if workoutManager.heartRate < 126.5 {
                            Image("75")
                        } else if workoutManager.heartRate < 128.8 {
                            Image("74")
                        } else if workoutManager.heartRate < 131.1 {
                            Image("73")
                        } else if workoutManager.heartRate < 133.4 {
                            Image("72")
                        } else if workoutManager.heartRate < 135.7 {
                            Image("71")
                        } else if workoutManager.heartRate < 138.0 {
                            Image("70")
                        } else if workoutManager.heartRate < 140.3 {
                            Image("69")
                        } else if workoutManager.heartRate < 142.6 {
                            Image("68")
                        } else if workoutManager.heartRate < 144.9 {
                            Image("67")
                        } else if workoutManager.heartRate < 147.2 {
                            Image("66")
                        } else if workoutManager.heartRate < 149.5 {
                            Image("65")
                        } else if workoutManager.heartRate < 151.8 {
                            Image("64")
                        } else if workoutManager.heartRate < 154.1 {
                            Image("63")
                        }
                        else if workoutManager.heartRate < 156.4 {
                            Image("62")
                        } else if workoutManager.heartRate < 157.15 {
                            Image("61")
                        } else if workoutManager.heartRate < 157.9 {
                            Image("60")
                        } else if workoutManager.heartRate < 158.65 {
                            Image("59")
                        } else if workoutManager.heartRate < 159.4 {
                            Image("58")
                        } else if workoutManager.heartRate < 160.15 {
                            Image("57")
                        } else if workoutManager.heartRate < 160.9 {
                            Image("56")
                        } else if workoutManager.heartRate < 161.65 {
                            Image("55")
                        } else if workoutManager.heartRate < 162.4 {
                            Image("54")
                        } else if workoutManager.heartRate < 163.15 {
                            Image("53")
                        } else if workoutManager.heartRate < 163.9 {
                            Image("52")
                        } else if workoutManager.heartRate < 164.65 {
                            Image("51")
                        } else if workoutManager.heartRate < 165.4 {
                            Image("50")
                        } else if workoutManager.heartRate < 166.15 {
                            Image("49")
                        } else if workoutManager.heartRate < 166.9 {
                            Image("48")
                        } else if workoutManager.heartRate < 167.65 {
                            Image("47")
                        } else if workoutManager.heartRate < 168.4 {
                            Image("46")
                        } else if workoutManager.heartRate < 169.15 {
                            Image("45")
                        } else if workoutManager.heartRate < 169.9 {
                            Image("44")
                        } else if workoutManager.heartRate < 170.65 {
                            Image("43")
                        } else if workoutManager.heartRate < 171.4 {
                            Image("42")
                        } else if workoutManager.heartRate < 172.15 {
                            Image("41")
                        } else if workoutManager.heartRate < 172.9 {
                            Image("40")
                        } else if workoutManager.heartRate < 173.65 {
                            Image("39")
                        } else if workoutManager.heartRate < 174.4 {
                            Image("38")
                        } else if workoutManager.heartRate < 175.15 {
                            Image("37")
                        } else if workoutManager.heartRate < 175.9 {
                            Image("36")
                        } else if workoutManager.heartRate < 176.65 {
                            Image("35")
                        } else if workoutManager.heartRate < 177.4 {
                            Image("34")
                        } else if workoutManager.heartRate < 178.15 {
                            Image("33")
                        } else if workoutManager.heartRate < 178.9 {
                            Image("32")
                        } else if workoutManager.heartRate < 179.65 {
                            Image("31")
                        } else if workoutManager.heartRate < 180.4 {
                            Image("30")
                        } else if workoutManager.heartRate < 181.15 {
                            Image("29")
                        } else if workoutManager.heartRate < 181.9 {
                            Image("28")
                        } else if workoutManager.heartRate < 182.65 {
                            Image("27")
                        } else if workoutManager.heartRate < 183.4 {
                            Image("26")
                        } else if workoutManager.heartRate < 184.15 {
                            Image("25")
                        }

                        else if workoutManager.heartRate < 184.9 {
                            Image("24")
                        } else if workoutManager.heartRate < 185.65 {
                            Image("23")
                        } else if workoutManager.heartRate < 186.4 {
                            Image("22")
                        } else if workoutManager.heartRate < 187.15 {
                            Image("21")
                        } else if workoutManager.heartRate < 187.9 {
                            Image("20")
                        } else if workoutManager.heartRate < 188.65 {
                            Image("19")
                        } else if workoutManager.heartRate < 189.4 {
                            Image("18")
                        } else if workoutManager.heartRate < 190.15 {
                            Image("17")
                        } else if workoutManager.heartRate < 190.9 {
                            Image("16")
                        } else if workoutManager.heartRate < 191.65 {
                            Image("15")
                        } else if workoutManager.heartRate < 192.4 {
                            Image("14")
                        } else if workoutManager.heartRate < 193.15 {
                            Image("13")
                        } else if workoutManager.heartRate < 193.9 {
                            Image("12")
                        } else if workoutManager.heartRate < 194.65 {
                            Image("11")
                        } else if workoutManager.heartRate < 195.4 {
                            Image("10")
                        } else if workoutManager.heartRate < 196.15 {
                            Image("9")
                        } else if workoutManager.heartRate < 196.9 {
                            Image("8")
                        } else if workoutManager.heartRate < 197.65 {
                            Image("7")
                        } else if workoutManager.heartRate < 198.4 {
                            Image("6")
                        } else if workoutManager.heartRate < 199.15 {
                            Image("5")
                        } else if workoutManager.heartRate < 199.9 {
                            Image("4")
                        } else if workoutManager.heartRate < 200.65 {
                            Image("3")
                        } else if workoutManager.heartRate < 201.4 {
                            Image("2")
                        } else {
                            Image("1")
                        }                       
                    }
                  
                    .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .ignoresSafeArea(edges: .bottom)
                    .scenePadding()
                }
            }
        }
    }
    
    private func authorizeLegacyHealthKit() {
        let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let restingEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        legacyHealthStore.requestAuthorization(toShare: nil, read: Set([activeEnergyType, restingEnergyType])) { (success, error) in
            if success {
                print("Successfully authorized to read active and resting energy data")
            } else {
                print("Failed to authorize to read active and resting energy data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func startLegacyActiveEnergyQuery() {
        let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        let query = HKStatisticsQuery(quantityType: activeEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to retrieve active energy data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.legacyActiveEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
        }
        legacyHealthStore.execute(query)
    }
    
    private func startLegacyRestingEnergyQuery() {
        let restingEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)
        let query = HKStatisticsQuery(quantityType: restingEnergyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to retrieve resting energy data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.legacyRestingEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
        }
        legacyHealthStore.execute(query)
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView().environmentObject(WorkoutManager())
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool

    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate,
                                                    by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
}

