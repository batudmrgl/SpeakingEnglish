import Foundation

@MainActor
protocol TextToSpeechService: AnyObject {
    func speak(_ text: String, level: CEFRLevel) async
    func stop()
}

