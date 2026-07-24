import SwiftUI

@main
struct EnglishCoachApp: App {
    @StateObject private var container = AppContainer(
        configuration: AppConfiguration(
            useMockServices: true,
            backendBaseURL: nil
        )
    )

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(container)
                .environmentObject(container.appState)
        }
    }
}

