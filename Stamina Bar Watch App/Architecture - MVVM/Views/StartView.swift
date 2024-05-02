import SwiftUI
import HealthKit

struct WorkoutType: Identifiable {
    var id: HKWorkoutActivityType {
        return workoutType
    }
    let workoutType: HKWorkoutActivityType
    let workoutSupportingImage: String
}

struct StartView: View {
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var showingSettings = false // State to control settings view presentation
    @State private var rotateGear = false
    
    
    var workoutTypes: [WorkoutType] = [
        WorkoutType(workoutType: .walking, workoutSupportingImage: "custom.StaminaBar")
    ]
    
    var body: some View {
        VStack {
            Spacer()
            if let workoutType = workoutTypes.first {
                NavigationLink(destination: SessionPagingView(),
                               tag: workoutType.workoutType,
                               selection: $workoutManager.selectedWorkout) {
                    HStack {
                        Image(workoutType.workoutSupportingImage)
                        Text("Start Stamina Bar")
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }
                               .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.blue, lineWidth: 2))
            }
            
            Spacer()
            
            
            
            Image(systemName: "gearshape")
                .foregroundColor(.white)
                .imageScale(.large)
                .padding(10)
                .background(Circle().fill(Color.white.opacity(0.1)))
                .rotationEffect(.degrees(rotateGear ? 360 : 0)) // Apply rotation
                .animation(.easeInOut(duration: 0.75), value: rotateGear) // Animation configuration
                .onTapGesture {
                    rotateGear = true // Trigger rotation
                    
                    // Delay to allow animation to complete before showing settings
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showingSettings = true
                        rotateGear = false // Reset rotation
                    }
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsView() // Settings view to show
                }
            
        }
        .navigationBarTitle("Stamina Bar")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(ConditionalScrollIndicatorModifier(shouldHide: shouldShowOnboarding))
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        })
    }
}


struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(WorkoutManager())
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

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }
    
    var name: String {
        switch self {
        case .walking:
            return "Start Stamina Bar"
        default:
            return ""
        }
    }
}
