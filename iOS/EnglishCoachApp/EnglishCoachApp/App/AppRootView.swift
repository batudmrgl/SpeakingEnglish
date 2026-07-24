import SwiftUI

struct AppRootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            if appState.hasCompletedOnboarding {
                HomeView()
            } else {
                OnboardingView()
            }
        }
    }
}

