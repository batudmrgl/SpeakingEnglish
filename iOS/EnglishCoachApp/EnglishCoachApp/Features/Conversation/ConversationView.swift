import SwiftUI

struct ConversationView: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModelHolder = ViewModelHolder<ConversationViewModel>()
    @State private var report: LessonReport?

    var body: some View {
        content
            .navigationTitle("Canli Diyalog")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Bitir") {
                    if let viewModel = viewModelHolder.value {
                        report = viewModel.finishLesson()
                    }
                }
            }
            .sheet(item: $report) { report in
                LessonReportView(report: report)
            }
            .task {
                if viewModelHolder.value == nil {
                    viewModelHolder.value = ConversationViewModel(
                        aiService: container.aiService,
                        speechService: container.speechService,
                        textToSpeechService: container.textToSpeechService,
                        historyStore: container.lessonHistoryStore,
                        profile: UserProfile.current(from: appState)
                    )
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if let viewModel = viewModelHolder.value {
            ConversationContentView(viewModel: viewModel)
        } else {
            ProgressView()
        }
    }
}

private struct ConversationContentView: View {
    @ObservedObject var viewModel: ConversationViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        TeacherHeader()

                        ForEach(viewModel.messages) { message in
                            TranscriptBubble(message: message)
                                .id(message.id)
                        }

                        if viewModel.isWaitingForTeacher {
                            ProgressView("Ogretmen dusunuyor")
                                .padding()
                        }

                        if let latestCorrection = viewModel.corrections.last {
                            CorrectionCardView(correction: latestCorrection)
                        }

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) {
                    if let last = viewModel.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            Divider()

            VStack(spacing: 10) {
                if viewModel.isRecording {
                    Text(viewModel.liveTranscript.isEmpty ? "Dinliyorum..." : viewModel.liveTranscript)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack(spacing: 10) {
                    TextField("Ingilizce cevap yaz", text: $viewModel.typedMessage, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...3)

                    Button {
                        Task { await viewModel.sendTypedMessage() }
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.typedMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                    Button {
                        Task { await viewModel.toggleRecording() }
                    } label: {
                        Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
    }
}

private struct TeacherHeader: View {
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                Image(systemName: "person.wave.2.fill")
                    .foregroundStyle(.blue)
            }
            .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 3) {
                Text("Maya")
                    .font(.headline)
                Text("AI Ingilizce ogretmenin")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
    }
}

