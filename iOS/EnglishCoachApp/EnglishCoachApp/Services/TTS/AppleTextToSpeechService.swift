import AVFoundation
import Foundation

@MainActor
final class AppleTextToSpeechService: NSObject, TextToSpeechService, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private var continuation: CheckedContinuation<Void, Never>?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String, level: CEFRLevel) async {
        stop()

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = rate(for: level)
        utterance.pitchMultiplier = 1.0

        await withCheckedContinuation { continuation in
            self.continuation = continuation
            synthesizer.speak(utterance)
        }
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        continuation?.resume()
        continuation = nil
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            continuation?.resume()
            continuation = nil
        }
    }

    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didCancel utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            continuation?.resume()
            continuation = nil
        }
    }

    private func rate(for level: CEFRLevel) -> Float {
        switch level {
        case .a1:
            return 0.42
        case .a2:
            return 0.45
        case .b1:
            return 0.48
        case .b2, .c1:
            return 0.52
        }
    }
}
