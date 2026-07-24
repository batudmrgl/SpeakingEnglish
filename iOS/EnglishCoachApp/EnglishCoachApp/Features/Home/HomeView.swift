import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Bugun ne calisalim?")
                        .font(.title2.bold())
                    Text("\(appState.selectedLevel.title) seviyesi - \(appState.selectedGoal.title)")
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            Section("Moduller") {
                ForEach(PracticeModule.allCases) { module in
                    NavigationLink(value: module) {
                        ModuleRow(module: module)
                    }
                }
            }

            Section {
                NavigationLink("Ders gecmisi", destination: HistoryView())
                NavigationLink("Ayarlar", destination: SettingsView())
            }
        }
        .navigationTitle("EnglishCoach")
        .navigationDestination(for: PracticeModule.self) { module in
            switch module {
            case .englishToTurkish, .turkishToEnglish:
                ExerciseView(module: module)
            case .listening:
                ListeningExerciseView()
            case .liveDialogue:
                ConversationView()
            }
        }
    }
}

private struct ModuleRow: View {
    let module: PracticeModule

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: module.systemImage)
                .font(.title2)
                .frame(width: 36, height: 36)
                .foregroundStyle(module == .liveDialogue ? .blue : .primary)

            VStack(alignment: .leading, spacing: 4) {
                Text(module.title)
                    .font(.headline)
                Text(module.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

