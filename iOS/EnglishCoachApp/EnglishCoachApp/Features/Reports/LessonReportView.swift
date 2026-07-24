import SwiftUI

struct LessonReportView: View {
    let report: LessonReport
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Puanlar") {
                    ScoreRow(title: "Genel", value: report.overallScore)
                    ScoreRow(title: "Gramer", value: report.grammarScore)
                    ScoreRow(title: "Kelime", value: report.vocabularyScore)
                    ScoreRow(title: "Akicilik", value: report.fluencyScore)
                }

                Section("Konusma") {
                    LabeledContent("Toplam kelime", value: "\(report.userWordCount)")
                    LabeledContent("Farkli kelime", value: "\(report.uniqueWordCount)")
                }

                if !report.importantCorrections.isEmpty {
                    Section("Onemli hatalar") {
                        ForEach(report.importantCorrections) { correction in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(correction.original)
                                Text(correction.corrected)
                                    .font(.subheadline.weight(.semibold))
                                Text(correction.explanationTR)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Guclu noktalar") {
                    ForEach(report.strengths, id: \.self) { item in
                        Text(item)
                    }
                }

                Section("Gelistirme") {
                    ForEach(report.improvements, id: \.self) { item in
                        Text(item)
                    }
                }

                Section("Odev") {
                    Text(report.homework)
                }
            }
            .navigationTitle("Ders Ozeti")
            .toolbar {
                Button("Kapat") {
                    dismiss()
                }
            }
        }
    }
}

private struct ScoreRow: View {
    let title: String
    let value: Int

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(value)")
                .font(.headline)
            ProgressView(value: Double(value), total: 100)
                .frame(width: 90)
        }
    }
}

