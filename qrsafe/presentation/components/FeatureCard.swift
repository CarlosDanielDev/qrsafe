import SwiftUI

struct FeatureCard: View {
    let iconName: String
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.qsLargeTitle)
                .frame(width: 50)
                .padding(.trailing, 10)
            Text(description)
            Spacer()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.qsWarning)
                .opacity(0.25)
                .brightness(-0.4)
        }
        .foregroundStyle(.qsBackground)
    }
}


#Preview {
    FeatureCard(iconName: "lock.shield.fill", description: "Fast QR scanning")
}
