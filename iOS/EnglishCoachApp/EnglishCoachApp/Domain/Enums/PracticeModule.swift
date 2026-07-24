import Foundation

enum PracticeModule: String, CaseIterable, Identifiable, Codable {
    case englishToTurkish
    case turkishToEnglish
    case listening
    case liveDialogue

    var id: String { rawValue }

    var title: String {
        switch self {
        case .englishToTurkish:
            return "Ingilizceden Turkceye"
        case .turkishToEnglish:
            return "Turkceden Ingilizceye"
        case .listening:
            return "Dinleme"
        case .liveDialogue:
            return "Canli Diyalog"
        }
    }

    var subtitle: String {
        switch self {
        case .englishToTurkish:
            return "Ingilizce cumleyi dogru anlamaya calis."
        case .turkishToEnglish:
            return "Turkce cumleyi dogal Ingilizceye cevir."
        case .listening:
            return "Duydugun metne gore sorulari cevapla."
        case .liveDialogue:
            return "AI ogretmenle surekli sohbet et."
        }
    }

    var systemImage: String {
        switch self {
        case .englishToTurkish:
            return "text.book.closed"
        case .turkishToEnglish:
            return "square.and.pencil"
        case .listening:
            return "headphones"
        case .liveDialogue:
            return "waveform.and.mic"
        }
    }
}

