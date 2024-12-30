import HealthKit
import SwiftUI
import TipKit

struct StartView: View {
    let staminaCalculationAlgorithm = StaminaCalculationAlgorithm()
    @ObservedObject var healthKitModel = HealthKitModel()
    @State private var currentIndex = 0
    @State private var showInfoPage = false
    
    func getGradientBackground(for percentage: CGFloat) -> Color {
        let color: Color
        switch percentage {
        case 91...100:
            color = .blue
        case 86...90:
            color = .green
        case 51...85:
            color = .yellow
        case 30...50:
            color = .orange
        case 1...29:
            color = .red
        default:
            color = .clear
        }
        return color
    }
    
    var body: some View {
        
        let (staminaView, staminaPercentage) =
        staminaCalculationAlgorithm.stressFunction(
            heart_rate: healthKitModel.latestHeartRate,
            hrv: healthKitModel.latestHeartRateVariability
        )
        
        let staminaValueGradient = CGFloat(Double(staminaPercentage) ?? 0)
        
        TabView {
            VStack(alignment: .trailing) {
                TipView(SimpleInlineTip())
                
                staminaView
                    .id(staminaPercentage)
                    .accessibilityElement()
                    .accessibilityLabel(
                        Text("Stamina percentage is \(staminaPercentage)%"))
                
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showInfoPage = true
                            } label: {
                                Image(systemName:"info")
                                    .foregroundStyle(.white)
                            }
                        }
                    } .sheet(isPresented: $showInfoPage) {
                        SettingsView() // Settings view to show
                    }
            }
            
            .padding()
            .containerBackground(
                getGradientBackground(for: staminaValueGradient).gradient,
                for: .tabView
            )
            .cornerRadius(10)
            
            
            VStack(alignment: .leading) {
                List {
                    
                    // MARK: Total Calories
                    VStack (alignment: .leading) {
                        Text("Total Cals")
                            .font(.headline)
                        HStack {
                            Text(healthKitModel.totalCalories.formatted(.number.precision(.fractionLength(0))))
                                .font(.title2)
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 24))
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray.gradient.opacity(0.5))
                            .padding(2)
                    )
                    
                    // MARK: ACTIVE CALS
                    VStack (alignment: .leading) {
                        Text("Active Cals")
                            .font(.headline)
                        HStack {
                            Text(healthKitModel.latestActiveEnergy.formatted(.number.precision(.fractionLength(0))))
                                .font(.title2)
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 24))
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray.gradient.opacity(0.5))
                            .padding(2)
                    )
                    
                    // MARK: BASAL CALORIES
                    VStack (alignment: .leading) {
                        Text("Basal Cals")
                            .font(.headline)
                        HStack {
                            Text(healthKitModel.latestRestingEnergy.formatted(.number.precision(.fractionLength(0))))
                                .font(.title2)
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 24))
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray.gradient.opacity(0.5))
                            .padding(2)
                    )
                    
                    // MARK: STEPS
                    VStack (alignment: .leading) {
                        Text("Steps")
                            .font(.headline)
                        HStack {
                            Text(healthKitModel.latestStepCount.formatted(.number.precision(.fractionLength(0))))
                                .font(.title2)
                            Image(systemName: "shoeprints.fill")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.system(size: 24))
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray.gradient.opacity(0.5))
                            .padding(2)
                    )
                    .accessibilityEnhanced(
                        label: "Steps: \(healthKitModel.latestStepCount) steps",
                        hint: "Displays the latest heart rate Variability measured using HealthKit"
                    )
                    
                   
                    
                    VStack(alignment: .leading) {
                        Text("Heart Rate")
                            .font(.headline)
                        HStack {
                            Text(healthKitModel.latestHeartRate.formatted(.number.precision(.fractionLength(0))))
                                .font(.title2)
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 24))
                                .accessibilityHidden(true)
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray.gradient.opacity(0.5))
                            .padding(2)
                    )
                    .accessibilityEnhanced(
                        label: "Heart Rate: \(healthKitModel.latestHeartRate) beats per minute",
                        hint: "Displays the latest heart rate measured using HealthKit"
                    )
                  
                    
                    // MARK: HRV
                    VStack (alignment: .leading) {
                        Text("HRV")
                            .font(.headline)
                        
                        HStack {
                            Text(healthKitModel.latestHeartRateVariability.formatted(.number.precision(.fractionLength(0))))
                                .font(.title2)
                            Image(systemName: "waveform.path.ecg")
                                .foregroundColor(.blue)
                                .font(.system(size: 24))
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray.gradient.opacity(0.5))
                            .padding(2)
                    )
                    .accessibilityEnhanced(
                        label: "HRV: \(healthKitModel.latestHeartRateVariability)",
                        hint: "Displays the latest heart rate Variability measured using HealthKit"
                    )
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text("Respiratory Rate")
                            .font(.headline)
                        HStack {
                            Text(healthKitModel.latestRespiratoryRate.formatted(.number.precision(.fractionLength(1))))
                                .font(.title2)
                            Image(systemName: "lungs.fill")
                                .foregroundColor(.teal)
                                .font(.system(size: 24))
                                .accessibilityHidden(true)
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray.gradient.opacity(0.5))
                            .padding(2)
                    )
                    
                    
                    VStack (alignment: .leading) {
                        Text("V02 Max")
                            .font(.headline)
                        HStack {
                            // Display latest VO₂ Max value
                            Text(healthKitModel.latestV02Max.formatted(.number.precision(.fractionLength(1))))
                                .font(.title2)
                            
                            // Lungs icon
                            Image(systemName: "figure.run")
                                .foregroundColor(.green)
                                .font(.system(size: 24))
                            
                            // Display trend symbol
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 16) // Set desired corner radius here
                            .fill(.gray.gradient.opacity(0.5))
                            .padding(2)
                    )
                    .accessibilityEnhanced(
                        label: "V02 Max: \(healthKitModel.latestV02Max) steps",
                        hint: "Displays the latest V02 Max measured using HealthKit"
                    )
                    
                }
            }
                .containerBackground(
                    getGradientBackground(for: staminaValueGradient).gradient,
                    for: .tabView
                )
            
        }
        .tabViewStyle(.verticalPage)
        .onAppear {
            healthKitModel.requestAuthorization()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
