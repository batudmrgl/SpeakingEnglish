import Foundation

struct UserProfile: Codable, Equatable {
    var nativeLanguage: String
    var level: CEFRLevel
    var goal: LearningGoal
    var correctionIntensity: CorrectionIntensity

    static func current(from appState: AppState) -> UserProfile {
        UserProfile(
            nativeLanguage: "Turkish",
            level: appState.selectedLevel,
            goal: appState.selectedGoal,
            correctionIntensity: appState.correctionIntensity
        )
    }
}

