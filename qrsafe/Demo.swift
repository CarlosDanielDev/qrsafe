import SwiftUI

enum QSColors {
    static let background = Color("QSBackground")
    static let surface = Color("QSSurface")
    static let textPrimary = Color("QSTextPrimary")
    static let textSecondary = Color("QSTextSecondary")
    static let separator = Color("QSSeparator")
    static let accent = Color("QSAccent")
    static let onAccent = Color("QSOnAccent")
    static let safe = Color("QSSafe")
    static let warning = Color("QSWarning")
    static let danger = Color("QSDanger")
}

struct Demo: View {
    @State private var isDark = false

    private let tokens: [(Color, String)] = [
        (QSColors.background, "Background"),
        (QSColors.surface, "Surface"),
        (QSColors.textPrimary, "Text Primary"),
        (QSColors.textSecondary, "Text Secondary"),
        (QSColors.separator, "Separator"),
        (QSColors.accent, "Accent"),
        (QSColors.onAccent, "On Accent"),
        (QSColors.safe, "Safe"),
        (QSColors.warning, "Warning"),
        (QSColors.danger, "Danger"),
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                QSColors.background.ignoresSafeArea()

                VStack(spacing: 16) {
                    Toggle("Drk mode", isOn: $isDark)
                        .tint(QSColors.accent)
                        .foregroundStyle(QSColors.textPrimary)
                        .padding(.horizontal)

                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(tokens, id: \.1) { color, name in
                                swatchRow(color: color, name: name)
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .preferredColorScheme(isDark ? .dark : .light)

        }
    }

    private func swatchRow(color: Color, name: String) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 56, height: 42)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(QSColors.separator, lineWidth: 1)
                )
            Text(name)
                .foregroundStyle(QSColors.textPrimary)

            Spacer()
        }
        .padding(10)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Light") {
    Demo()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    Demo()
        .preferredColorScheme(.dark)
}
