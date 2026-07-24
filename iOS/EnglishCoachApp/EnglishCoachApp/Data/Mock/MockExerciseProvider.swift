import Foundation

struct MockExerciseProvider {
    private let englishToTurkish: [ExercisePrompt] = [
        ExercisePrompt(
            module: .englishToTurkish,
            promptText: "I usually take a walk after dinner.",
            expectedAnswer: "Genellikle aksam yemeginden sonra yuruyuse cikarim."
        ),
        ExercisePrompt(
            module: .englishToTurkish,
            promptText: "She has been studying English for two years.",
            expectedAnswer: "O iki yildir Ingilizce calisiyor."
        )
    ]

    private let turkishToEnglish: [ExercisePrompt] = [
        ExercisePrompt(
            module: .turkishToEnglish,
            promptText: "Dun alisveris merkezine gittim.",
            expectedAnswer: "I went to the shopping mall yesterday."
        ),
        ExercisePrompt(
            module: .turkishToEnglish,
            promptText: "Uc yildir burada calisiyorum.",
            expectedAnswer: "I have been working here for three years."
        )
    ]

    private let listening: [ExercisePrompt] = [
        ExercisePrompt(
            module: .listening,
            promptText: "Sarah went to the market because she wanted to buy fresh fruit.",
            expectedAnswer: "Because she wanted to buy fresh fruit.",
            supportText: "Metni dinle ve soruyu cevapla.",
            questions: ["Why did Sarah go to the market?"]
        ),
        ExercisePrompt(
            module: .listening,
            promptText: "Tom missed the bus, so he arrived late for his meeting.",
            expectedAnswer: "Because he missed the bus.",
            supportText: "Metni dinle ve soruyu cevapla.",
            questions: ["Why was Tom late for his meeting?"]
        )
    ]

    func prompts(for module: PracticeModule) -> [ExercisePrompt] {
        switch module {
        case .englishToTurkish:
            return englishToTurkish
        case .turkishToEnglish:
            return turkishToEnglish
        case .listening:
            return listening
        case .liveDialogue:
            return []
        }
    }
}

