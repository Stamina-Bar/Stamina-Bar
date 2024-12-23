import HealthKit
import SwiftUI
import TipKit

struct StartView: View {
    let staminaCalculationAlgorithm = StaminaCalculationAlgorithm()
    @ObservedObject var healthKitModel = HealthKitModel()
    @State private var currentIndex = 0
    @State private var showHKPage = false
    @State private var showInfoPage = false
    
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
                
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showInfoPage = true
                                // Perform an action here.
                            } label: {
                                Image(systemName:"info")
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                
                    .sheet(isPresented: $showInfoPage) {
                        SettingsView() // Settings view to show
                    }
                
                    .accessibilityElement()
            }
            .onAppear {
                healthKitModel.requestAuthorization()
                healthKitModel.fetchDailyStepCount()
            }
            .padding()
            .containerBackground(
                getGradientBackground(for: staminaValueGradient).gradient,
                for: .tabView
            )
            .cornerRadius(10)
        }        .tabViewStyle(.verticalPage)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
