import Foundation

@MainActor
final class ConversationViewModel: ObservableObject {
    @Published private(set) var messages: [ConversationMessage] = []
    @Published private(set) var corrections: [Correction] = []
    @Published private(set) var isWaitingForTeacher = false
    @Published private(set) var errorMessage: String?
    @Published var typedMessage = ""
    @Published private(set) var startedAt = Date()

    private let aiService: AIService
    private let speechService: SpeechRecognitionService
    private let textToSpeechService: TextToSpeechService
    private let historyStore: LessonHistoryStore
    private let profile: UserProfile

    init(
        aiService: AIService,
        speechService: SpeechRecognitionService,
        textToSpeechService: TextToSpeechService,
        historyStore: LessonHistoryStore,
        profile: UserProfile
    ) {
        self.aiService = aiService
        self.speechService = speechService
        self.textToSpeechService = textToSpeechService
        self.historyStore = historyStore
        self.profile = profile
        self.messages = [
            ConversationMessage(
                role: .assistant,
                text: "Hi. I am your English teacher today. How are you feeling?"
            )
        ]
    }

    func sendTypedMessage() async {
        let text = typedMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        typedMessage = ""
        await send(text)
    }

    func toggleRecording() async {
        if speechService.isRecording {
            speechService.stopTranscribing()
            let text = speechService.transcript
            await send(text)
            return
        }

        textToSpeechService.stop()

        do {
            try await speechService.startTranscribing()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func finishLesson() -> LessonReport {
        let userText = messages
            .filter { $0.role == .user }
            .map(\.text)
            .joined(separator: " ")

        let words = userText
            .lowercased()
            .split { !$0.isLetter }
            .map(String.init)

        let penalty = min(corrections.count * 8, 35)
        let grammar = max(100 - penalty, 45)
        let vocabulary = min(70 + Set(words).count * 2, 95)
        let fluency = words.count >= 25 ? 82 : 64
        let overall = (grammar + vocabulary + fluency) / 3

        let report = LessonReport(
            module: .liveDialogue,
            startedAt: startedAt,
            userWordCount: words.count,
            uniqueWordCount: Set(words).count,
            grammarScore: grammar,
            vocabularyScore: vocabulary,
            fluencyScore: fluency,
            overallScore: overall,
            importantCorrections: corrections,
            strengths: ["Sohbete cevap verdin", "Anlasilir cumleler kurmaya basladin"],
            improvements: corrections.isEmpty ? ["Bir sonraki derste daha uzun cevaplar dene"] : ["Tekrarlanan gramer hatalarina dikkat et"],
            homework: "Bugun konustugun konu hakkinda 5 cumlelik kisa bir paragraf yaz."
        )

        historyStore.save(report: report)
        return report
    }

    var isRecording: Bool {
        speechService.isRecording
    }

    var liveTranscript: String {
        speechService.transcript
    }

    private func send(_ text: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = AppError.emptyInput.localizedDescription
            return
        }

        errorMessage = nil
        textToSpeechService.stop()
        messages.append(ConversationMessage(role: .user, text: trimmed))
        isWaitingForTeacher = true

        do {
            let response = try await aiService.sendConversationMessage(
                messages: messages,
                userText: trimmed,
                profile: profile
            )

            if response.shouldCorrect {
                corrections.append(contentsOf: response.corrections)
            }

            messages.append(ConversationMessage(role: .assistant, text: response.assistantReply))
            isWaitingForTeacher = false
            await textToSpeechService.speak(response.assistantReply, level: profile.level)
        } catch {
            isWaitingForTeacher = false
            errorMessage = error.localizedDescription
        }
    }
}

