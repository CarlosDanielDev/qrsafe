import SwiftUI

enum PillSize {
    case small
    case medium
    case large
}

struct Pill: View {
    var value: String
    var color: Color = .blue
    var size: PillSize = .medium
    
    func getSpacing() -> CGFloat {
        switch size {
        case .small:
            return 4
        case .medium:
            return 8
        case .large:
            return 16
        }
    }
    
    func getFontSize() -> Font {
        switch size {
        case .small:
            return .caption
        case .medium:
            return .callout
        case .large:
            return .body
        }
    }

    var body: some View {
        HStack(spacing: getSpacing()) {
            Text(value)
                .foregroundStyle(.primary)
                .font(getFontSize())
                .padding(getSpacing())
        }
        .background(
            Capsule()
                .fill(color)
        )
    }
}
