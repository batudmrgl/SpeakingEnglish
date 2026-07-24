import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedLevel: CEFRLevel = .a2
    @State private var selectedGoal: LearningGoal = .dailyConversation

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("EnglishCoach")
                        .font(.largeTitle.bold())
                    Text("AI ogretmenle konus, ceviri yap, dinle ve hatalarini aninda ogren.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Seviyeni sec")
                        .font(.headline)

                    ForEach(CEFRLevel.allCases) { level in
                        SelectionRow(
                            title: level.title,
                            subtitle: level.description,
                            isSelected: selectedLevel == level
                        ) {
                            selectedLevel = level
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Hedefin")
                        .font(.headline)

                    ForEach(LearningGoal.allCases) { goal in
                        SelectionRow(
                            title: goal.title,
                            subtitle: goal.description,
                            isSelected: selectedGoal == goal
                        ) {
                            selectedGoal = goal
                        }
                    }
                }

                PrimaryButton("Basla", systemImage: "arrow.right.circle") {
                    appState.completeOnboarding(level: selectedLevel, goal: selectedGoal)
                }
            }
            .padding(20)
        }
        .navigationTitle("Kurulum")
    }
}

private struct SelectionRow: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .blue : .secondary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding()
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

