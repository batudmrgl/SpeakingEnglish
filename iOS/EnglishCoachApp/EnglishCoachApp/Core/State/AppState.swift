import Foundation

final class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool {
        didSet { defaults.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding) }
    }

    @Published var selectedLevel: CEFRLevel {
        didSet { defaults.set(selectedLevel.rawValue, forKey: Keys.selectedLevel) }
    }

    @Published var selectedGoal: LearningGoal {
        didSet { defaults.set(selectedGoal.rawValue, forKey: Keys.selectedGoal) }
    }

    @Published var correctionIntensity: CorrectionIntensity {
        didSet { defaults.set(correctionIntensity.rawValue, forKey: Keys.correctionIntensity) }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.hasCompletedOnboarding = defaults.bool(forKey: Keys.hasCompletedOnboarding)
        self.selectedLevel = CEFRLevel(rawValue: defaults.string(forKey: Keys.selectedLevel) ?? "") ?? .a2
        self.selectedGoal = LearningGoal(rawValue: defaults.string(forKey: Keys.selectedGoal) ?? "") ?? .dailyConversation
        self.correctionIntensity = CorrectionIntensity(rawValue: defaults.string(forKey: Keys.correctionIntensity) ?? "") ?? .balanced
    }

    func completeOnboarding(level: CEFRLevel, goal: LearningGoal) {
        selectedLevel = level
        selectedGoal = goal
        hasCompletedOnboarding = true
    }

    func resetOnboarding() {
        hasCompletedOnboarding = false
    }
}

private enum Keys {
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
    static let selectedLevel = "selectedLevel"
    static let selectedGoal = "selectedGoal"
    static let correctionIntensity = "correctionIntensity"
}
