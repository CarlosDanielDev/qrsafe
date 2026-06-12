import SwiftUI

struct QSPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    var backgroundColor: Color {
       if isEnabled {
            .qsAccent
        } else {
            .qsAccent.opacity(0.5)
       }
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, QSSpacing.sm)
            .padding(.horizontal, QSSpacing.lg)
            .background(backgroundColor)
            .foregroundColor(.qsBackground)
            .font(.qsTitle)
            .cornerRadius(QSSpacing.md)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
