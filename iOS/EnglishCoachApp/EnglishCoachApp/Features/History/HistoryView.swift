import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var container: AppContainer
    @State private var reports: [LessonReport] = []

    var body: some View {
        List {
            if reports.isEmpty {
                ContentUnavailableView(
                    "Henuz ders yok",
                    systemImage: "clock",
                    description: Text("Bir konusma dersini bitirdiginde burada gorunecek.")
                )
            } else {
                ForEach(reports) { report in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(report.module.title)
                            .font(.headline)
                        Text(report.finishedAt, style: .date)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Genel puan: \(report.overallScore)")
                            .font(.subheadline.weight(.semibold))
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Ders gecmisi")
        .onAppear {
            reports = container.lessonHistoryStore.loadReports()
        }
    }
}

