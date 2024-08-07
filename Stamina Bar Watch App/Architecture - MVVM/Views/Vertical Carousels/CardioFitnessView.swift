////
////  CardioFitnessView.swift
////  Stamina Bar Watch App
////
////  Created by Bryce Ellis on 10/10/23.
////
//
//
//import SwiftUI
//import HealthKit
//
//struct CardioFitnessView: View {
//    
//    @EnvironmentObject var workoutManager: WorkoutManager
//    @Environment(\.scenePhase) private var scenePhase
//    
//    let staminaBarView = StaminaBarView()
//    
//    var body: some View {
//        
//        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(), isPaused: workoutManager.session?.state == .paused)) { context in
//            
//            VStack (alignment: .trailing) {
//                if workoutManager.running {
//                    ElapsedTimeView(elapsedTime: workoutManager.builder?.elapsedTime(at: context.date) ?? 0)
//                        .foregroundStyle(.white)
//                        .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                        .scenePadding()
//                }
//                (staminaBarView.stressFunction(heart_rate: workoutManager.heartRate) as AnyView)
//                
//                
//                HStack {
//                    Text("\(String(format: "%.1f", workoutManager.currentVO2Max)) VO2 max")
//                        .font(.system(.body, design:
//                                .rounded).monospacedDigit().lowercaseSmallCaps())
//                    
//                    Image(systemName: "lungs.fill")
//                        .foregroundColor(.green)
//                    
//                }
//            }
//        }
//    }
//}
//
//
//struct CardioFitnessView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardioFitnessView().environmentObject(WorkoutManager())
//    }
//}
//
//private struct MetricsTimelineSchedule: TimelineSchedule {
//    var startDate: Date
//    var isPaused: Bool
//    
//    init(from startDate: Date, isPaused: Bool) {
//        self.startDate = startDate
//        self.isPaused = isPaused
//    }
//    
//    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
//        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate,
//                                                    by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
//            .entries(from: startDate, mode: mode)
//        
//        return AnyIterator<Date> {
//            guard !isPaused else { return nil }
//            return baseSchedule.next()
//        }
//    }
//}
