import HealthKit
import SwiftUI
import TipKit

struct StartView: View {
    let staminaCalculationAlgorithm = StaminaCalculationAlgorithm()
    @ObservedObject var healthKitModel = HealthKitModel()
    @State private var currentIndex = 0
    @State private var showHKPage = false
    
    
    //    MARK: SF Symbols
    func displaySymbol() -> String? {
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
    
    //    MARK: Background gradient colors
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
    
    func getGradientBackground(for percentage: CGFloat) -> Color {
        let color: Color
        switch percentage {
        case 91...100:
            color = .blue  // High stamina
        case 86...90:
            color = .green  // Medium-high stamina
        case 51...85:
            color = .yellow  // Medium stamina
        case 30...50:
            color = .orange  // Medium-low stamina
        case 1...29:
            color = .red  // Low stamina
        default:
            color = .clear  // 0 or negative values (if possible)
        }
        
        return color
    }
    
    //    MARK: Format Steps
    func formattedStepCount(_ stepCount: Int, abbreviate: Bool = true) -> String
    {
        if abbreviate && stepCount >= 1000 {
            let formatted = Double(stepCount) / 1000.0
            return String(format: "%.1fK", formatted)
        } else {
            // Use NumberFormatter to format with commas
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedStepCount =
            numberFormatter.string(from: NSNumber(value: stepCount))
            ?? "\(stepCount)"
            return "\(formattedStepCount)"
        }
    }
    
    //    MARK: PAGES
    func displayHK() -> String? {
        switch currentIndex {
        case 0:
            return nil
        case 2:
            return healthKitModel.latestHeartRate.formatted(
                .number.precision(.fractionLength(0))) + " BPM"
        case 3:
            return healthKitModel.latestHeartRateVariability.formatted(
                .number.precision(.fractionLength(0))) + " HRV"
        case 4:
            return healthKitModel.latestV02Max.formatted(
                .number.precision(.fractionLength(1))) + " V02 Max"
        case 5:
            return healthKitModel.latestStepCount.formatted(
                .number.precision(.fractionLength(0))) + " Steps"
        default:
            return nil
        }
    }
    
    //    MARK: Shows all pages
    func allMetricsView() -> some View {
        VStack {
            // Arrange metrics around the stamina bar
            HStack(spacing: 18) {
                VStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                    Text(
                        healthKitModel.latestHeartRate.formatted(
                            .number.precision(.fractionLength(0)))
                    )
                    //
                    .font(
                        .system(.headline, design: .rounded)
                        .smallCaps())
                    .bold()
                    .layoutPriority(1)
                    .fixedSize(horizontal: true, vertical: false)
                    
                }
                
                VStack {
                    Image(systemName: "waveform.path.ecg")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                    
                    Text(
                        healthKitModel.latestHeartRateVariability.formatted(
                            .number.precision(.fractionLength(0)))
                    )
                    //                     Text("100")
                    .font(
                        .system(.headline, design: .rounded)
                        .smallCaps())
                    .bold()
                    .layoutPriority(1)
                    .fixedSize(horizontal: true, vertical: false)
                    
                }
                
                VStack {
                    Image(systemName: "lungs.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                    
                    Text(
                        healthKitModel.latestV02Max.formatted(
                            .number.precision(.fractionLength(1)))
                    )
                    //                    Text("90.9")
                    .font(
                        .system(.headline, design: .rounded)
                        .smallCaps())
                    .bold()
                    .layoutPriority(1)
                    .fixedSize(horizontal: true, vertical: false)
                    
                    
                }
                
                // Conditionally display step count without "Steps" text if < 1,000
                if healthKitModel.latestStepCount >= 1000 {
                    VStack {
                        Image(systemName: "shoeprints.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                        
                        Text(
                            formattedStepCount(
                                healthKitModel.latestStepCount, abbreviate: true
                            )
                        )
                        //   Text("10.2K")
                        .font(
                            .system(.headline, design: .rounded)
                            .smallCaps())
                        .bold()
                        .layoutPriority(1)
                        .fixedSize(horizontal: true, vertical: false)
                        
                        
                    }
                } else {
                    VStack {
                        Image(systemName: "shoeprints.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                        
                        Text("\(healthKitModel.latestStepCount)")
                        //Text("10.2K")
                        
                        // Just the number, no "Steps" label
                            .font(
                                .system(.headline, design: .rounded)
                                .smallCaps())
                            .bold()
                            .layoutPriority(1)
                            .fixedSize(horizontal: true, vertical: false)
                        
                    }
                }
            }
        }
    }
    
    var body: some View {
        
        let (staminaView, staminaPercentage) =
        staminaCalculationAlgorithm.stressFunction(
            heart_rate: healthKitModel.latestHeartRate,
            hrv: healthKitModel.latestHeartRateVariability
        )
        
        let staminaValue = CGFloat(Double(staminaPercentage) ?? 0)
        
        /*if #available(watchOS 10.0, *)*/
        
        TabView {
            VStack(alignment: .trailing) {
                TipView(SimpleInlineTip())
                
                staminaView
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                showHKPage = true
                                // Perform an action here.
                            } label: {
                                Image(systemName:"chart.line.uptrend.xyaxis")
                            }
                        }
                    }
                
                    .sheet(isPresented: $showHKPage) {
                        HealthKitPage() // Settings view to show
                    }
                
                    .accessibilityElement()
                    .accessibilityLabel(
                        Text("Stamina percentage is \(staminaPercentage)%"))
                
                if currentIndex == 1 {
                    allMetricsView()
                } else {
                    // Display one metric at a time
                    HStack(spacing: 10) {
                        if let healthMetric = displayHK(),
                           let sfSymbol = displaySymbol()
                        {
                            Text(healthMetric)
                                .font(
                                    .system(.headline, design: .rounded)
                                    .monospacedDigit())
                            Image(systemName: sfSymbol)
                                .font(.system(size: 24))
                                .foregroundColor(displayedForegroundColor())
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
            .onAppear {
                healthKitModel.requestAuthorization()
                healthKitModel.fetchDailyStepCount()
            }
            .padding()
            .containerBackground(
                getGradientBackground(for: staminaValue).gradient,
                for: .tabView
            )
            .cornerRadius(10)
            .onTapGesture {
                healthKitModel.requestAuthorization()
                healthKitModel.fetchDailyStepCount()
                currentIndex = (currentIndex + 1) % 6  // Cycle through the states
                HapticManager.clickHaptic()
            }
        }        
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
