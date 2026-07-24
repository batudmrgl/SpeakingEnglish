import Foundation

struct ExercisePrompt: Identifiable, Codable, Equatable {
    let id: UUID
    let module: PracticeModule
    let promptText: String
    let expectedAnswer: String
    let supportText: String?
    let questions: [String]

    init(
        id: UUID = UUID(),
        module: PracticeModule,
        promptText: String,
        expectedAnswer: String,
        supportText: String? = nil,
        questions: [String] = []
    ) {
        self.id = id
        self.module = module
        self.promptText = promptText
        self.expectedAnswer = expectedAnswer
        self.supportText = supportText
        self.questions = questions
    }
}

struct ExerciseEvaluation: Codable, Equatable {
    let isCorrect: Bool
    let score: Int
    let feedbackTR: String
    let correctedAnswer: String
    let explanationTR: String
    let nextPromptHint: String?

    enum CodingKeys: String, CodingKey {
        case isCorrect = "is_correct"
        case score
        case feedbackTR = "feedback_tr"
        case correctedAnswer = "corrected_answer"
        case explanationTR = "explanation_tr"
        case nextPromptHint = "next_prompt_hint"
    }
}

