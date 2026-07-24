import Foundation

enum CEFRLevel: String, CaseIterable, Identifiable, Codable {
    case a1 = "A1"
    case a2 = "A2"
    case b1 = "B1"
    case b2 = "B2"
    case c1 = "C1"

    var id: String { rawValue }

    var title: String { rawValue }

    var description: String {
        switch self {
        case .a1:
            return "Basit kelimeler ve kisa cumlelerle baslamak istiyorum."
        case .a2:
            return "Gunluk konularda daha rahat cumle kurmak istiyorum."
        case .b1:
            return "Daha uzun cevaplar verip akici konusmak istiyorum."
        case .b2:
            return "Daha dogal ve detayli konusmak istiyorum."
        case .c1:
            return "Akademik ve profesyonel seviyede pratik yapmak istiyorum."
        }
    }
}

