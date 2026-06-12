import SwiftUI

struct OnboardingView: View {
    var body: some View {
        TabView {
            WelcomeView()
            FeaturesView()
        }
        .background(Gradient(colors: gradientColors))
        .tabViewStyle(.page)
        .foregroundStyle(.qsBackground)
    }
}

#Preview {
    OnboardingView()
}
