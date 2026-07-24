import Foundation

protocol LessonHistoryStore {
    func loadReports() -> [LessonReport]
    func save(report: LessonReport)
}

final class UserDefaultsLessonHistoryStore: LessonHistoryStore {
    private let key = "lessonReports"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadReports() -> [LessonReport] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder.appDecoder.decode([LessonReport].self, from: data)) ?? []
    }

    func save(report: LessonReport) {
        var reports = loadReports()
        reports.insert(report, at: 0)
        guard let data = try? JSONEncoder.appEncoder.encode(reports) else { return }
        defaults.set(data, forKey: key)
    }
}

