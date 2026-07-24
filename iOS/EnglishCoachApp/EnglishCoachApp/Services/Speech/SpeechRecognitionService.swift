import Foundation

@MainActor
protocol SpeechRecognitionService: AnyObject {
    var transcript: String { get }
    var isRecording: Bool { get }

    func requestPermissions() async throws
    func startTranscribing() async throws
    func stopTranscribing()
}

