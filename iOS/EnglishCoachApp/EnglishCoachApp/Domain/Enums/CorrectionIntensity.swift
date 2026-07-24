import Foundation

enum CorrectionIntensity: String, CaseIterable, Identifiable, Codable {
    case fluent
    case balanced
    case teacher
    case endOfLesson

    var id: String { rawValue }

    var title: String {
        switch self {
        case .fluent:
            return "Akici sohbet"
        case .balanced:
            return "Dengeli"
        case .teacher:
            return "Ogretmen modu"
        case .endOfLesson:
            return "Ders sonunda"
        }
    }
}

