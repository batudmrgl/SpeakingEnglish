import Foundation

final class BackendAIService: AIService {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func evaluateExercise(
        prompt: ExercisePrompt,
        userAnswer: String,
        profile: UserProfile
    ) async throws -> ExerciseEvaluation {
        let requestBody = ExerciseEvaluationRequest(
            prompt: prompt,
            userAnswer: userAnswer,
            profile: profile
        )
        return try await post(path: "exercise-evaluate", body: requestBody)
    }

    func sendConversationMessage(
        messages: [ConversationMessage],
        userText: String,
        profile: UserProfile
    ) async throws -> TeacherResponse {
        let requestBody = ConversationMessageRequest(
            messages: messages,
            userText: userText,
            profile: profile
        )
        return try await post(path: "conversation-message", body: requestBody)
    }

    private func post<Request: Encodable, Response: Decodable>(
        path: String,
        body: Request
    ) async throws -> Response {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder.appEncoder.encode(body)

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.networkUnavailable
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw AppError.backend("Sunucu su anda cevap veremiyor. Lutfen tekrar dene.")
        }

        do {
            return try JSONDecoder.appDecoder.decode(Response.self, from: data)
        } catch {
            throw AppError.invalidServerResponse
        }
    }
}

private struct ExerciseEvaluationRequest: Encodable {
    let prompt: ExercisePrompt
    let userAnswer: String
    let profile: UserProfile
}

private struct ConversationMessageRequest: Encodable {
    let messages: [ConversationMessage]
    let userText: String
    let profile: UserProfile
}
