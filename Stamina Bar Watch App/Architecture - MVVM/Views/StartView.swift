import SwiftUI
import HealthKit

//struct WorkoutType: Identifiable {
//    var id: HKWorkoutActivityType {
//        return workoutType
//    }
//    let workoutType: HKWorkoutActivityType
//    let workoutSupportingImage: String
//}

struct StartView: View {
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    //    @EnvironmentObject var workoutManager: WorkoutManager
    //    @State private var showingSettings = false 
    //    @State private var rotateGear = false
    let staminaBarView2 = StaminaBarView2()
    let staminaBarViewSeniorCitizens = StaminaBarViewSeniorCitizens()

    @ObservedObject var healthKitModel = HealthKitModel()
    
    
    //    var workoutTypes: [WorkoutType] = [
    //        WorkoutType(workoutType: .walking, workoutSupportingImage: "custom.StaminaBar")
    //    ]
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        if healthKitModel.userAgeInYears <= 28 {
            TabView(selection: $selectedTab) {
                //            MARK:
                VStack {
                    staminaBarView2.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
                    
                    if healthKitModel.latestHeartRate == 0 {
                        Text("Reading heart rate")
                            .font(.subheadline)
                    }
                }
                .tag(0)
                
                VStack(alignment: .trailing) {
                    staminaBarView2.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
                    HStack {
                        Text(healthKitModel.latestHeartRate.formatted(.number.precision(.fractionLength(0))) + " BPM")
                            .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
                .tag(1)
                
                
                VStack(alignment: .trailing) {
                    staminaBarView2.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
                    HStack {
                        Text(healthKitModel.latestHeartRateVariability.formatted(.number.precision(.fractionLength(0))) + " HRV")
                            .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        Image(systemName: "waveform.path.ecg")
                            .foregroundColor(.blue)
                    }
                }
                .tag(2)
                
                VStack(alignment: .trailing) {
                    staminaBarView2.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
                    HStack {
                        Text("\(String(format: "%.1f", healthKitModel.latestV02Max)) VO2 max")
                            .font(.system(.body, design:
                                    .rounded).monospacedDigit().lowercaseSmallCaps())
                        
                        Image(systemName: "lungs.fill")
                            .foregroundColor(.green)
                        
                    }
                }
                .tag(3)
                
                VStack(alignment: .trailing) {
                    staminaBarView2.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
                    HStack {
                        Text("\(healthKitModel.latestStepCount) Steps")
                            .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        Image(systemName: "shoeprints.fill")
                            .foregroundColor(.blue)
                    }
                }
                .onTapGesture {
                    healthKitModel.fetchDailyStepCount()
                }
                .onAppear {
                    healthKitModel.fetchDailyStepCount()
                }
                .tag(4)
            }
            .tabViewStyle(.carousel)
            .navigationBarTitle("Stamina Bar")
            .navigationBarTitleDisplayMode(.inline)

        } else {
            TabView(selection: $selectedTab) {
                //            MARK:
                VStack {
                    staminaBarViewSeniorCitizens.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
                    
                    if healthKitModel.latestHeartRate == 0 {
                        Text("Reading heart rate")
                            .font(.subheadline)
                    }
                }
                .tag(0)
                
                VStack(alignment: .trailing) {
                    staminaBarViewSeniorCitizens.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
                    HStack {
                        Text(healthKitModel.latestHeartRate.formatted(.number.precision(.fractionLength(0))) + " BPM")
                            .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                }
                .tag(1)
                
                
                VStack(alignment: .trailing) {
                    staminaBarViewSeniorCitizens.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
                    HStack {
                        Text(healthKitModel.latestHeartRateVariability.formatted(.number.precision(.fractionLength(0))) + " HRV")
                            .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        Image(systemName: "waveform.path.ecg")
                            .foregroundColor(.blue)
                    }
                }
                .tag(2)
                
                VStack(alignment: .trailing) {
                    staminaBarViewSeniorCitizens.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
                    HStack {
                        Text("\(String(format: "%.1f", healthKitModel.latestV02Max)) VO2 max")
                            .font(.system(.body, design:
                                    .rounded).monospacedDigit().lowercaseSmallCaps())
                        
                        Image(systemName: "lungs.fill")
                            .foregroundColor(.green)
                        
                    }
                }
                .tag(3)
                
                VStack(alignment: .trailing) {
                    staminaBarViewSeniorCitizens.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
                    HStack {
                        Text("\(healthKitModel.latestStepCount) Steps")
                            .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                        Image(systemName: "shoeprints.fill")
                            .foregroundColor(.blue)
                    }
                }
                .onTapGesture {
                    healthKitModel.fetchDailyStepCount()
                }
                .onAppear {
                    healthKitModel.fetchDailyStepCount()
                }
                .tag(4)
            }
            .tabViewStyle(.carousel)
            .navigationBarTitle("Stamina Bar")
            .navigationBarTitleDisplayMode(.inline)

        }
        
        //        VStack {
        //            Spacer()
        //            if let workoutType = workoutTypes.first {
        //                NavigationLink(destination: SessionPagingView(),
        //                               tag: workoutType.workoutType,
        //                               selection: $workoutManager.selectedWorkout) {
        //                    HStack {
        //                        Text("Start any Exercise")
        //                            .lineLimit(1)
        //                            .minimumScaleFactor(0.5)
        //                    }
        //                }
        //                               .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.blue, lineWidth: 2))
        //            }
        //                        
        //            
        //            
        //            Image(systemName: "info.circle.fill")
        //                .foregroundColor(.blue)
        //                .frame(width: 60, height: 60)
        //
        //                
        //        //                .background(Circle().fill(Color.white.opacity(0.1)))
        //                .onTapGesture {
        //                    
        //                        showingSettings = true
        //                    
        //                }
        //                .sheet(isPresented: $showingSettings) {
        //                    SettingsView() // Settings view to show
        //                }
        //            
        //        }
        //        .modifier(ConditionalScrollIndicatorModifier(shouldHide: shouldShowOnboarding))
        //        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
        //            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        //        })
    }
}


struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        //        let workoutManager = WorkoutManager()
        StartView()
        //            .environmentObject(workoutManager)
    }
}

struct ConditionalScrollIndicatorModifier: ViewModifier {
    var shouldHide: Bool
    
    func body(content: Content) -> some View {
        if #available(watchOS 9.0, *) {
            return AnyView(content.scrollIndicators(shouldHide ? .hidden : .visible))
        } else {
            return AnyView(content)
        }
    }
}

//extension HKWorkoutActivityType: Identifiable {
//    public var id: UInt {
//        rawValue
//    }
//    
//    var name: String {
//        switch self {
//        case .walking:
//            return "Start Stamina Bar"
//        default:
//            return ""
//        }
//    }
//}
