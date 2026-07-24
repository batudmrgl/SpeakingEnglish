import Foundation

protocol AIService {
    func evaluateExercise(
        prompt: ExercisePrompt,
        userAnswer: String,
        profile: UserProfile
    ) async throws -> ExerciseEvaluation

    func sendConversationMessage(
        messages: [ConversationMessage],
        userText: String,
        profile: UserProfile
    ) async throws -> TeacherResponse
}

