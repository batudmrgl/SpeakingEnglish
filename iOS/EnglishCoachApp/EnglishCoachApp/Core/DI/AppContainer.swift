import Foundation

@MainActor
final class AppContainer: ObservableObject {
    let configuration: AppConfiguration
    let appState: AppState
    let aiService: AIService
    let speechService: SpeechRecognitionService
    let textToSpeechService: TextToSpeechService
    let lessonHistoryStore: LessonHistoryStore

    init(configuration: AppConfiguration) {
        self.configuration = configuration
        self.appState = AppState()
        self.speechService = AppleSpeechRecognitionService()
        self.textToSpeechService = AppleTextToSpeechService()
        self.lessonHistoryStore = UserDefaultsLessonHistoryStore()

        if configuration.useMockServices {
            self.aiService = MockAIService()
        } else if let backendBaseURL = configuration.backendBaseURL {
            self.aiService = BackendAIService(baseURL: backendBaseURL)
        } else {
            self.aiService = MockAIService()
        }
    }
}
