import Foundation

enum LearningGoal: String, CaseIterable, Identifiable, Codable {
    case dailyConversation
    case travel
    case business
    case grammar
    case confidence

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dailyConversation:
            return "Gunluk konusma"
        case .travel:
            return "Seyahat"
        case .business:
            return "Is Ingilizcesi"
        case .grammar:
            return "Gramer guclendirme"
        case .confidence:
            return "Konusma cesareti"
        }
    }

    var description: String {
        switch self {
        case .dailyConversation:
            return "Gundelik sorulara daha dogal cevap vermek."
        case .travel:
            return "Yurt disi seyahatlerinde rahat konusmak."
        case .business:
            return "Toplanti, sunum ve musteri gorusmelerinde gelismek."
        case .grammar:
            return "Cumle kurarken daha az hata yapmak."
        case .confidence:
            return "Cekingenligi azaltip daha cok konusmak."
        }
    }
}

