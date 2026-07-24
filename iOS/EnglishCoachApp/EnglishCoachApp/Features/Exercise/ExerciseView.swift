import SwiftUI

struct ExerciseView: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var appState: AppState
    let module: PracticeModule

    @StateObject private var viewModelHolder = ViewModelHolder<ExerciseViewModel>()

    var body: some View {
        content
            .navigationTitle(module.title)
            .task {
                if viewModelHolder.value == nil {
                    let provider = MockExerciseProvider()
                    viewModelHolder.value = ExerciseViewModel(
                        module: module,
                        prompts: provider.prompts(for: module),
                        aiService: container.aiService,
                        speechService: container.speechService,
                        profile: UserProfile.current(from: appState)
                    )
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if let viewModel = viewModelHolder.value {
            ExerciseContentView(viewModel: viewModel)
        } else {
            ProgressView()
        }
    }
}

private struct ExerciseContentView: View {
    @ObservedObject var viewModel: ExerciseViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(viewModel.prompt.promptText)
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Cevabin")
                        .font(.headline)
                    TextEditor(text: $viewModel.answerText)
                        .frame(minHeight: 120)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.separator), lineWidth: 1)
                        )
                }

                if viewModel.isRecording {
                    Text(viewModel.liveTranscript.isEmpty ? "Dinliyorum..." : viewModel.liveTranscript)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Button {
                        Task { await viewModel.toggleRecording() }
                    } label: {
                        Label(
                            viewModel.isRecording ? "Kaydi bitir" : "Sesli cevap",
                            systemImage: viewModel.isRecording ? "stop.circle" : "mic.circle"
                        )
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

                if viewModel.isChecking {
                    ProgressView("Kontrol ediliyor")
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }

                if let evaluation = viewModel.evaluation {
                    EvaluationCard(evaluation: evaluation) {
                        viewModel.nextPrompt()
                    }
                }
            }
            .padding()
        }
    }
}

private struct EvaluationCard: View {
    let evaluation: ExerciseEvaluation
    let nextAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(
                evaluation.isCorrect ? "Dogru" : "Tekrar bakalim",
                systemImage: evaluation.isCorrect ? "checkmark.seal.fill" : "exclamationmark.triangle.fill"
            )
            .font(.headline)
            .foregroundStyle(evaluation.isCorrect ? .green : .orange)

            Text(evaluation.feedbackTR)
            Text("Dogru cevap: \(evaluation.correctedAnswer)")
                .font(.subheadline.weight(.semibold))
            Text(evaluation.explanationTR)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            PrimaryButton("Yeni metin", systemImage: "arrow.right.circle", action: nextAction)
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
    }
}

