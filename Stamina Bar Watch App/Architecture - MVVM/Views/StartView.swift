import HealthKit
import SwiftUI
import TipKit

struct StartView: View {
    let staminaCalculationAlgorithm = StaminaCalculationAlgorithm()
    @ObservedObject var healthKitModel = HealthKitModel()
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
                //                TipView(SimpleInlineTip())
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
                        SettingsView()
                    }
            }
            .padding()
            .containerBackground(
                getGradientBackground(for: staminaValueGradient).gradient,
                for: .tabView
            )
            .cornerRadius(10)
            VStack(alignment: .leading) {
                TipView(SimpleInlineTip())
                List {
                    TotalCaloriesView(healthKitModel: healthKitModel)
                    RestingCaloriesView(healthKitModel: healthKitModel)
                    ActiveCaloriesView(healthKitModel: healthKitModel)
                    StepsView(healthKitModel: healthKitModel)
                    HeartRateView(healthKitModel: healthKitModel)
                    HRVView(healthKitModel: healthKitModel)
                    RespiratoryRateView(healthKitModel: healthKitModel)
                    V02MaxView(healthKitModel: healthKitModel)
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
