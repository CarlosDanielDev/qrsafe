import SwiftUI

struct TorchButton: View {
    var isTorchOn: Bool
    var onToggle: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Button {
                onToggle()
            } label: {
                Image(
                    systemName: isTorchOn
                        ? "flashlight.on.fill" : "flashlight.slash"
                )
            }
            .toggleStyle(.button)
            .tint(.qsWarning)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .onChange(of: isTorchOn) { _, newValue in
                onToggle()
            }
        }
        .padding()
    }

}
