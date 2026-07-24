import SwiftUI

struct ListeningExerciseView: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModelHolder = ViewModelHolder<ListeningExerciseViewModel>()

    var body: some View {
        content
            .navigationTitle("Dinleme")
            .task {
                if viewModelHolder.value == nil {
                    let provider = MockExerciseProvider()
                    viewModelHolder.value = ListeningExerciseViewModel(
                        prompts: provider.prompts(for: .listening),
                        aiService: container.aiService,
                        speechService: container.speechService,
                        textToSpeechService: container.textToSpeechService,
                        profile: UserProfile.current(from: appState)
                    )
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if let viewModel = viewModelHolder.value {
            ListeningContentView(viewModel: viewModel)
        } else {
            ProgressView()
        }
    }
}

private struct ListeningContentView: View {
    @ObservedObject var viewModel: ListeningExerciseViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Metni dinle")
                    .font(.title2.bold())

                Button {
                    Task { await viewModel.playPrompt() }
                } label: {
                    Label("Sesi oynat", systemImage: "play.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Soru")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(viewModel.questionText)
                        .font(.title3.weight(.semibold))
                }
                .padding()
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))

                TextEditor(text: $viewModel.answerText)
                    .frame(minHeight: 120)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.separator), lineWidth: 1)
                    )

                HStack {
                    Button {
                        Task { await viewModel.toggleRecording() }
                    } label: {
                        Label(viewModel.isRecording ? "Kaydi bitir" : "Sesli cevap", systemImage: "mic.circle")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        Task { await viewModel.checkAnswer() }
                    } label: {
                        Label("Kontrol et", systemImage: "checkmark.circle")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isChecking)
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }

                if let evaluation = viewModel.evaluation {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(evaluation.isCorrect ? "Dogru" : "Kismen dogru")
                            .font(.headline)
                        Text(evaluation.feedbackTR)
                        Text("Beklenen cevap: \(evaluation.correctedAnswer)")
                            .font(.subheadline.weight(.semibold))
                        Text(evaluation.explanationTR)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        PrimaryButton("Yeni dinleme", systemImage: "arrow.right.circle") {
                            viewModel.nextPrompt()
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()
        }
    }
}

