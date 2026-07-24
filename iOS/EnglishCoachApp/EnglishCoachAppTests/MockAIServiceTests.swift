import XCTest
@testable import EnglishCoachApp

final class MockAIServiceTests: XCTestCase {
    func testPastTenseCorrectionIsReturned() async throws {
        let service = MockAIService()
        let profile = UserProfile(
            nativeLanguage: "Turkish",
            level: .a2,
            goal: .dailyConversation,
            correctionIntensity: .balanced
        )

        let response = try await service.sendConversationMessage(
            messages: [],
            userText: "Yesterday I go to shopping mall.",
            profile: profile
        )

        XCTAssertTrue(response.shouldCorrect)
        XCTAssertEqual(response.corrections.first?.errorType, "past_tense")
    }

    func testExerciseEvaluationAcceptsCloseMeaning() async throws {
        let service = MockAIService()
        let profile = UserProfile(
            nativeLanguage: "Turkish",
            level: .a2,
            goal: .dailyConversation,
            correctionIntensity: .balanced
        )
        let prompt = ExercisePrompt(
            module: .turkishToEnglish,
            promptText: "Dun alisveris merkezine gittim.",
            expectedAnswer: "I went to the shopping mall yesterday."
        )

        let result = try await service.evaluateExercise(
            prompt: prompt,
            userAnswer: "I went to the shopping mall yesterday",
            profile: profile
        )

        XCTAssertTrue(result.isCorrect)
        XCTAssertGreaterThanOrEqual(result.score, 80)
    }
}

