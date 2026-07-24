import Foundation

final class MockAIService: AIService {
    func evaluateExercise(
        prompt: ExercisePrompt,
        userAnswer: String,
        profile: UserProfile
    ) async throws -> ExerciseEvaluation {
        let normalizedUserAnswer = userAnswer.normalizedForLearningCheck
        let normalizedExpected = prompt.expectedAnswer.normalizedForLearningCheck
        let isClose = normalizedExpected.contains(normalizedUserAnswer) || normalizedUserAnswer.contains(normalizedExpected)
        let hasCommonMeaning = commonWordRatio(normalizedUserAnswer, normalizedExpected) >= 0.45
        let isCorrect = isClose || hasCommonMeaning

        if isCorrect {
            return ExerciseEvaluation(
                isCorrect: true,
                score: 90,
                feedbackTR: "Dogru. Anlami basarili sekilde verdin.",
                correctedAnswer: prompt.expectedAnswer,
                explanationTR: "Cevabin hedef anlamla uyumlu. Birebir ayni kelimeleri kullanman gerekmiyor.",
                nextPromptHint: "Yeni cumleye gecebiliriz."
            )
        }

        return ExerciseEvaluation(
            isCorrect: false,
            score: 45,
            feedbackTR: "Tam dogru degil. Anlam veya cumle yapisinda eksik var.",
            correctedAnswer: prompt.expectedAnswer,
            explanationTR: explanation(for: prompt, userAnswer: userAnswer),
            nextPromptHint: "Dogru cevabi okuyup benzer bir cumleyle tekrar deneyebilirsin."
        )
    }

    func sendConversationMessage(
        messages: [ConversationMessage],
        userText: String,
        profile: UserProfile
    ) async throws -> TeacherResponse {
        let text = userText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { throw AppError.emptyInput }

        if text.localizedCaseInsensitiveContains("yesterday i go") {
            let correction = Correction(
                original: text,
                highlightedPart: "Yesterday I go",
                corrected: text.replacingOccurrences(
                    of: "Yesterday I go",
                    with: "Yesterday I went",
                    options: [.caseInsensitive]
                ),
                errorType: "past_tense",
                explanationTR: "Gecmiste olan bir olaydan bahsettigin icin 'go' yerine 'went' kullanmalisin.",
                naturalAlternative: "I went there yesterday.",
                pronunciationTip: nil,
                severity: .medium
            )

            return TeacherResponse(
                assistantReply: "Nice. You went there yesterday. What did you do after that?",
                shouldCorrect: true,
                corrections: [correction],
                newVocabulary: [
                    VocabularySuggestion(
                        word: "after that",
                        meaningTR: "ondan sonra",
                        example: "What did you do after that?"
                    )
                ],
                followUpQuestion: "What did you do after that?"
            )
        }

        if text.split(separator: " ").count <= 3 {
            return TeacherResponse(
                assistantReply: "Good start. Can you tell me a little more? Try to answer with one full sentence.",
                shouldCorrect: false,
                corrections: [],
                newVocabulary: [],
                followUpQuestion: "Can you give me one more detail?"
            )
        }

        return TeacherResponse(
            assistantReply: reply(for: text, level: profile.level),
            shouldCorrect: false,
            corrections: [],
            newVocabulary: [],
            followUpQuestion: "Why do you think that?"
        )
    }

    private func reply(for text: String, level: CEFRLevel) -> String {
        switch level {
        case .a1, .a2:
            return "I understand. That is a good answer. Can you tell me more with a simple example?"
        case .b1:
            return "That makes sense. Can you explain why this is important for you?"
        case .b2, .c1:
            return "Interesting point. Let me challenge you a little: what could be the opposite view?"
        }
    }

    private func explanation(for prompt: ExercisePrompt, userAnswer: String) -> String {
        switch prompt.module {
        case .englishToTurkish:
            return "Burada onemli olan ana anlami korumak. Dogru anlam: \(prompt.expectedAnswer)"
        case .turkishToEnglish:
            return "Ingilizce cumlede zaman, kelime sirasi ve dogal kullanim birlikte dogru olmali."
        case .listening:
            return "Dinleme sorusunda metindeki sebep-sonuc iliskisine dikkat etmelisin."
        case .liveDialogue:
            return "Cevabini biraz daha acik kurmalisin."
        }
    }

    private func commonWordRatio(_ first: String, _ second: String) -> Double {
        let firstWords = Set(first.split(separator: " ").map(String.init))
        let secondWords = Set(second.split(separator: " ").map(String.init))
        guard !secondWords.isEmpty else { return 0 }
        return Double(firstWords.intersection(secondWords).count) / Double(secondWords.count)
    }
}

private extension String {
    var normalizedForLearningCheck: String {
        lowercased()
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "?", with: "")
            .replacingOccurrences(of: "!", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

