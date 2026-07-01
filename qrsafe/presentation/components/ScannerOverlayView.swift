import SwiftUI

struct Dim: View {
    var body: some View {
        GeometryReader { geo in
            let boxSize: CGFloat = 300
            let x = (geo.size.width - boxSize) / 2
            let y = (geo.size.height - boxSize) / 2
            let hole = CGRect(x: x, y: y, width: boxSize, height: boxSize)

            Path { path in
                path.addRect(CGRect(origin: .zero, size: geo.size))
                path.addRoundedRect(
                    in: hole,
                    cornerSize: CGSize(width: 16, height: 16),
                    style: .continuous
                )
            }
            .fill(.qsBackground.opacity(0.7), style: FillStyle(eoFill: true))
        }
        .accessibilityHidden(true)
    }
}

struct ScannerOverlayView: View {
    var body: some View {
        ZStack {
            Dim()
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.qsOnAccent, lineWidth: 3)
                .frame(width: 300, height: 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ScannerOverlayView()
}
