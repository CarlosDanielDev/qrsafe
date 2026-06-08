import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Features")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom)
                .padding(.top, 42)
            
            FeatureCard(
                iconName: "hare.circle.fill",
                description: "Fast QR scanning - real-time detection with the camera"
            )
            
            FeatureCard(
                iconName: "lock.shield.fill",
                description: "Safety analysis - checks the URL against phishing patterns and suspicious domains"
            )
            
            FeatureCard(
                iconName: "exclamationmark.bubble",
                description: "Plain-language verdict — color-coded result with why it's risky, in words anyone can read"
            )
            
            FeatureCard(
                iconName: "internaldrive",
                description: "Local history — every scan saved on-device, searchable; nothing leaves your phone"
            )
            
            FeatureCard(
                iconName: "globe.americas.fill",
                description: "6 languages — English, Português (BR), Español, 日本語, Français, 한국어"
            )
            
            FeatureCard(
                iconName: "hand.raised.fill",
                description: "Private by design — no login, no cloud, no analytics; analysis runs offline어"
            )
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomeView()
        .frame(maxHeight: .infinity)
        .background(Gradient(colors: gradientColors))
        .foregroundStyle(Color.white)
}
