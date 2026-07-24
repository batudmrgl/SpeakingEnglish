import Foundation

@MainActor
final class ListeningExerciseViewModel: ObservableObject {
    @Published private(set) var prompt: ExercisePrompt
    @Published var answerText: String = ""
    @Published private(set) var evaluation: ExerciseEvaluation?
    @Published private(set) var errorMessage: String?
    @Published private(set) var isChecking = false

    private let prompts: [ExercisePrompt]
    private let aiService: AIService
    private let speechService: SpeechRecognitionService
    private let textToSpeechService: TextToSpeechService
    private let profile: UserProfile
    private var currentIndex = 0

    init(
        prompts: [ExercisePrompt],
        aiService: AIService,
        speechService: SpeechRecognitionService,
        textToSpeechService: TextToSpeechService,
        profile: UserProfile
    ) {
        self.prompts = prompts
        self.prompt = prompts.first ?? ExercisePrompt(module: .listening, promptText: "", expectedAnswer: "")
        self.aiService = aiService
        self.speechService = speechService
        self.textToSpeechService = textToSpeechService
        self.profile = profile
    }

    func playPrompt() async {
        await textToSpeechService.speak(prompt.promptText, level: profile.level)
    }

    func checkAnswer() async {
        let trimmed = answerText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = AppError.emptyInput.localizedDescription
            return
        }

        isChecking = true
        errorMessage = nil

        do {
            evaluation = try await aiService.evaluateExercise(
                prompt: prompt,
                userAnswer: trimmed,
                profile: profile
            )
        } catch {
            errorMessage = error.localizedDescription
        }

        isChecking = false
    }

    func nextPrompt() {
        currentIndex = (currentIndex + 1) % max(prompts.count, 1)
        prompt = prompts[currentIndex]
        answerText = ""
        evaluation = nil
        errorMessage = nil
    }

    func toggleRecording() async {
        if speechService.isRecording {
            speechService.stopTranscribing()
            answerText = speechService.transcript
            return
        }

        do {
            try await speechService.startTranscribing()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    var isRecording: Bool {
        speechService.isRecording
    }

    var questionText: String {
        prompt.questions.first ?? "What did you understand?"
    }
}

