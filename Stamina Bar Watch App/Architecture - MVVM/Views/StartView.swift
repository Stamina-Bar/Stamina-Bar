import SwiftUI
import HealthKit

struct StartView: View {
    let staminaCalculationAlgorithm = StaminaCalculationAlgorithm()
    
    @ObservedObject var healthKitModel = HealthKitModel()
    
    @State private var currentIndex = 0
    
    func displayedValue() -> String? {
        switch currentIndex {
        case 0:
            return nil
        
        case 1:
            return healthKitModel.latestHeartRate.formatted(.number.precision(.fractionLength(0))) + " BPM"
        case 2:
            return healthKitModel.latestHeartRateVariability.formatted(.number.precision(.fractionLength(0))) + " HRV"
        case 3:
            return healthKitModel.latestV02Max.formatted(.number.precision(.fractionLength(1))) + " V02 Max"
        default:
            return healthKitModel.latestStepCount.formatted(.number.precision(.fractionLength(0))) + " Steps"
        }
    }
    
    func displayedSystemImage() -> String? {
        switch currentIndex {
        case 0:
            return nil
        case 1:
            return "heart.fill"
        case 2:
            return "waveform.path.ecg"
        case 3:
            return "lungs.fill"
        default:
            return "shoeprints.fill"
        }
    }
    
    func displayedForegroundColor() -> Color {
        switch currentIndex {
        case 0:
            return .clear
        case 1:
            return .red
        case 2:
            return .blue
        case 3:
            return .green
        default:
            return .blue
         }
    }
    
    
    var body: some View {
        //            MARK:
        VStack (alignment: .trailing) {
            staminaCalculationAlgorithm.stressFunction(heart_rate: healthKitModel.latestHeartRate, hrv: healthKitModel.latestHeartRateVariability)
            
            HStack {
                if let text = displayedValue(), let systemImage = displayedSystemImage() {
                    Text(text)
                        .font(.system(.body, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    Image(systemName: systemImage)
                        .foregroundColor(displayedForegroundColor())
                } else {
                    EmptyView()
                }
            }
        }
        .onTapGesture {
            currentIndex = (currentIndex + 1) % 5
        }
    }
}


struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
