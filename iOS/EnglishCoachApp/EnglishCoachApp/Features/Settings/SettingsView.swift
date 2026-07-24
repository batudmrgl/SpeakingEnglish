import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Form {
            Section("Duzeltme yogunlugu") {
                Picker("Mod", selection: $appState.correctionIntensity) {
                    ForEach(CorrectionIntensity.allCases) { intensity in
                        Text(intensity.title).tag(intensity)
                    }
                }
            }

            Section("Profil") {
                Picker("Seviye", selection: $appState.selectedLevel) {
                    ForEach(CEFRLevel.allCases) { level in
                        Text(level.title).tag(level)
                    }
                }

                Picker("Hedef", selection: $appState.selectedGoal) {
                    ForEach(LearningGoal.allCases) { goal in
                        Text(goal.title).tag(goal)
                    }
                }
            }

            Section {
                Button("Onboarding'i sifirla", role: .destructive) {
                    appState.resetOnboarding()
                }
            }
        }
        .navigationTitle("Ayarlar")
    }
}

