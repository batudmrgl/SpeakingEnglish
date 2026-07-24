import Foundation

struct LessonReport: Identifiable, Codable, Equatable {
    let id: UUID
    let module: PracticeModule
    let startedAt: Date
    let finishedAt: Date
    let userWordCount: Int
    let uniqueWordCount: Int
    let grammarScore: Int
    let vocabularyScore: Int
    let fluencyScore: Int
    let overallScore: Int
    let importantCorrections: [Correction]
    let strengths: [String]
    let improvements: [String]
    let homework: String

    init(
        id: UUID = UUID(),
        module: PracticeModule,
        startedAt: Date,
        finishedAt: Date = Date(),
        userWordCount: Int,
        uniqueWordCount: Int,
        grammarScore: Int,
        vocabularyScore: Int,
        fluencyScore: Int,
        overallScore: Int,
        importantCorrections: [Correction],
        strengths: [String],
        improvements: [String],
        homework: String
    ) {
        self.id = id
        self.module = module
        self.startedAt = startedAt
        self.finishedAt = finishedAt
        self.userWordCount = userWordCount
        self.uniqueWordCount = uniqueWordCount
        self.grammarScore = grammarScore
        self.vocabularyScore = vocabularyScore
        self.fluencyScore = fluencyScore
        self.overallScore = overallScore
        self.importantCorrections = importantCorrections
        self.strengths = strengths
        self.improvements = improvements
        self.homework = homework
    }
}

