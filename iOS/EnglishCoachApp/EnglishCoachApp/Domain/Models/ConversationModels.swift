import Foundation

struct ConversationMessage: Identifiable, Codable, Equatable {
    let id: UUID
    let role: SpeakerRole
    let text: String
    let createdAt: Date

    init(id: UUID = UUID(), role: SpeakerRole, text: String, createdAt: Date = Date()) {
        self.id = id
        self.role = role
        self.text = text
        self.createdAt = createdAt
    }
}

struct Correction: Identifiable, Codable, Equatable {
    let id: UUID
    let original: String
    let highlightedPart: String
    let corrected: String
    let errorType: String
    let explanationTR: String
    let naturalAlternative: String?
    let pronunciationTip: String?
    let severity: CorrectionSeverity

    init(
        id: UUID = UUID(),
        original: String,
        highlightedPart: String,
        corrected: String,
        errorType: String,
        explanationTR: String,
        naturalAlternative: String?,
        pronunciationTip: String?,
        severity: CorrectionSeverity
    ) {
        self.id = id
        self.original = original
        self.highlightedPart = highlightedPart
        self.corrected = corrected
        self.errorType = errorType
        self.explanationTR = explanationTR
        self.naturalAlternative = naturalAlternative
        self.pronunciationTip = pronunciationTip
        self.severity = severity
    }

    enum CodingKeys: String, CodingKey {
        case id
        case original
        case highlightedPart = "highlighted_part"
        case corrected
        case errorType = "error_type"
        case explanationTR = "explanation_tr"
        case naturalAlternative = "natural_alternative"
        case pronunciationTip = "pronunciation_tip"
        case severity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.original = try container.decode(String.self, forKey: .original)
        self.highlightedPart = try container.decode(String.self, forKey: .highlightedPart)
        self.corrected = try container.decode(String.self, forKey: .corrected)
        self.errorType = try container.decode(String.self, forKey: .errorType)
        self.explanationTR = try container.decode(String.self, forKey: .explanationTR)
        self.naturalAlternative = try container.decodeIfPresent(String.self, forKey: .naturalAlternative)
        self.pronunciationTip = try container.decodeIfPresent(String.self, forKey: .pronunciationTip)
        self.severity = try container.decode(CorrectionSeverity.self, forKey: .severity)
    }
}

enum CorrectionSeverity: String, Codable, Equatable {
    case low
    case medium
    case high
}

struct VocabularySuggestion: Identifiable, Codable, Equatable {
    let id: UUID
    let word: String
    let meaningTR: String
    let example: String

    init(id: UUID = UUID(), word: String, meaningTR: String, example: String) {
        self.id = id
        self.word = word
        self.meaningTR = meaningTR
        self.example = example
    }

    enum CodingKeys: String, CodingKey {
        case id
        case word
        case meaningTR = "meaning_tr"
        case example
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.word = try container.decode(String.self, forKey: .word)
        self.meaningTR = try container.decode(String.self, forKey: .meaningTR)
        self.example = try container.decode(String.self, forKey: .example)
    }
}

struct TeacherResponse: Codable, Equatable {
    let assistantReply: String
    let shouldCorrect: Bool
    let corrections: [Correction]
    let newVocabulary: [VocabularySuggestion]
    let followUpQuestion: String?

    enum CodingKeys: String, CodingKey {
        case assistantReply = "assistant_reply"
        case shouldCorrect = "should_correct"
        case corrections
        case newVocabulary = "new_vocabulary"
        case followUpQuestion = "follow_up_question"
    }
}
