import SwiftUI

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
            TabView {
                Tab("Colors", systemImage: "paintpalette.fill") {
                    VStack {
                        renderColors(geometry: geometry)
                    }
                }
                Tab("Typography", systemImage: "character") {
                    renderTypography(geometry: geometry)
                }
            }

        }
    }

    private func renderTypography(geometry: GeometryProxy) -> some View {
        ZStack {
            QSColors.background.ignoresSafeArea()

            VStack(spacing: QSSpacing.md) {
                Text("Verdict").font(Font.qsVerdict)
                Text("Title").font(Font.qsTitle)
                Text("heading").font(Font.qsHeading)
                Text("Body").font(Font.qsBody)
                Text("Secondary").font(Font.qsSecondary)
                Text("Caption").font(Font.qsCaption)
            }
            .foregroundStyle(QSColors.textPrimary)
        }
        .frame(width: geometry.size.width, height: geometry.size.height)

    }

    private func renderColors(geometry: GeometryProxy) -> some View {
        ZStack {
            QSColors.background.ignoresSafeArea()

            VStack(spacing: QSSpacing.md) {
                Toggle("Dark mode", isOn: $isDark)
                    .tint(QSColors.accent)
                    .foregroundStyle(QSColors.textPrimary)
                    .padding(.horizontal)

                ScrollView {
                    VStack(spacing: QSSpacing.sm) {
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

    private func swatchRow(color: Color, name: String) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: QSSpacing.sm)
                .fill(color)
                .frame(width: 56, height: 42)
                .overlay(
                    RoundedRectangle(cornerRadius: QSSpacing.sm)
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

#Preview("Large Text") {
    Demo().environment(\.dynamicTypeSize, .accessibility3)
}
