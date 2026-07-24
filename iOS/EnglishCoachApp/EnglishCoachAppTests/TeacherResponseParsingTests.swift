import XCTest
@testable import EnglishCoachApp

final class TeacherResponseParsingTests: XCTestCase {
    func testTeacherResponseParsesSnakeCaseJSON() throws {
        let json = """
        {
          "assistant_reply": "That sounds interesting. What did you do there?",
          "should_correct": true,
          "corrections": [
            {
              "original": "Yesterday I go to shopping mall.",
              "highlighted_part": "I go",
              "corrected": "Yesterday I went to the shopping mall.",
              "error_type": "past_tense",
              "explanation_tr": "Gecmisten bahsettigin icin went kullanmalisin.",
              "natural_alternative": "I went to the mall yesterday.",
              "pronunciation_tip": null,
              "severity": "medium"
            }
          ],
          "new_vocabulary": [
            {
              "word": "shopping mall",
              "meaning_tr": "alisveris merkezi",
              "example": "I went to the shopping mall yesterday."
            }
          ],
          "follow_up_question": "What did you buy there?"
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder.appDecoder.decode(TeacherResponse.self, from: json)

        XCTAssertEqual(response.assistantReply, "That sounds interesting. What did you do there?")
        XCTAssertTrue(response.shouldCorrect)
        XCTAssertEqual(response.corrections.count, 1)
        XCTAssertEqual(response.newVocabulary.first?.word, "shopping mall")
    }
}
