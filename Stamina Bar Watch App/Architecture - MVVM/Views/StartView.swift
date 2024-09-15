import SwiftUI
import HealthKit

struct StartView: View {
    let staminaCalculationAlgorithm = StaminaCalculationAlgorithm()
    @ObservedObject var healthKitModel = HealthKitModel()
    
    @State private var currentIndex = 0
    
    //    MARK: Extension Methods
    func displayedValue() -> String? {
        switch currentIndex {
        case 0:
            return nil
        case 2:
            return healthKitModel.latestHeartRate.formatted(.number.precision(.fractionLength(0))) + " BPM"
        case 3:
            return healthKitModel.latestHeartRateVariability.formatted(.number.precision(.fractionLength(0))) + " HRV"
        case 4:
            return healthKitModel.latestV02Max.formatted(.number.precision(.fractionLength(1))) + " V02 Max"
        case 5:
            return healthKitModel.latestStepCount.formatted(.number.precision(.fractionLength(0))) + " Steps"
        default:
            return nil
        }
    }
    
    func displayedSystemImage() -> String? {
        switch currentIndex {
        case 0:
            return nil
        case 2:
            return "heart.fill"
        case 3:
            return "waveform.path.ecg"
        case 4:
            return "lungs.fill"
        case 5:
            return "shoeprints.fill"
        default:
            return nil
        }
    }
    
    func displayedForegroundColor() -> Color {
        switch currentIndex {
        case 0:
            return .clear
        case 2:
            return .red
        case 3:
            return .blue
        case 4:
            return .green
        case 5:
            return .blue
        default:
            return .clear
        }
    }
    
    func formattedStepCount(_ stepCount: Int, abbreviate: Bool = true) -> String {
        if abbreviate && stepCount >= 1000 {
            let formatted = Double(stepCount) / 1000.0
            return String(format: "%.1fK", formatted)
        } else {
            // Use NumberFormatter to format with commas
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedStepCount = numberFormatter.string(from: NSNumber(value: stepCount)) ?? "\(stepCount)"
            return "\(formattedStepCount)"
        }
    }
    
    func allMetricsView() -> some View {
        VStack {
            // Arrange metrics around the stamina bar
            HStack(spacing: 10) {
                VStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    Text(healthKitModel.latestHeartRate.formatted(.number.precision(.fractionLength(0))))
                        .font(.system(.footnote, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                }
                
                VStack {
                    Image(systemName: "waveform.path.ecg")
                        .foregroundColor(.blue)
                    Text(healthKitModel.latestHeartRateVariability.formatted(.number.precision(.fractionLength(0))))
                        .font(.system(.footnote, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                }
                
                VStack {
                    Image(systemName: "lungs.fill")
                        .foregroundColor(.green)
                    Text(healthKitModel.latestV02Max.formatted(.number.precision(.fractionLength(1))))
                        .font(.system(.footnote, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                }
                
                // Conditionally display step count without "Steps" text if < 1,000
                if healthKitModel.latestStepCount >= 1000 {
                    VStack {
                        Image(systemName: "shoeprints.fill")
                            .foregroundColor(.blue)
                        Text(formattedStepCount(healthKitModel.latestStepCount, abbreviate: true)) // Abbreviated step count with "Steps"
                            .font(.system(.footnote, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    }
                } else {
                    VStack {
                        Image(systemName: "shoeprints.fill")
                            .foregroundColor(.blue)
                        Text("\(healthKitModel.latestStepCount)") // Just the number, no "Steps" label
                            .font(.system(.footnote, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    }
                }
            }
        }
    }
    
    var body: some View {
        
        if #available(watchOS 10.0, *) {
            TabView {
                VStack(alignment: .trailing) {
                    staminaCalculationAlgorithm.stressFunction(
                        heart_rate: healthKitModel.latestHeartRate,
                        hrv: healthKitModel.latestHeartRateVariability
                    )
                    
                    if currentIndex == 1 {
                        // Display all metrics around the stamina bar
                        allMetricsView()
                    } else {
                        // Display one metric at a time
                        HStack {
                            if let text = displayedValue(), let systemImage = displayedSystemImage() {
                                Text(text)
                                    .font(.system(.footnote, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                                Image(systemName: systemImage)
                                    .foregroundColor(displayedForegroundColor())
                            } else {
                                EmptyView()
                            }
                        }
                    }
                }
                .onTapGesture {
                    currentIndex = (currentIndex + 1) % 6 // Cycle through the states
                }
            }
            .containerBackground(.blue.gradient, for: .tabView)
        } else {
            VStack(alignment: .trailing) {
                staminaCalculationAlgorithm.stressFunction(
                    heart_rate: healthKitModel.latestHeartRate,
                    hrv: healthKitModel.latestHeartRateVariability
                )
                
                if currentIndex == 1 {
                    // Display all metrics around the stamina bar
                    allMetricsView()
                } else {
                    // Display one metric at a time
                    HStack {
                        if let text = displayedValue(), let systemImage = displayedSystemImage() {
                            Text(text)
                                .font(.system(.footnote, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                            Image(systemName: systemImage)
                                .foregroundColor(displayedForegroundColor())
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
            .onTapGesture {
                currentIndex = (currentIndex + 1) % 6 // Cycle through the states
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

