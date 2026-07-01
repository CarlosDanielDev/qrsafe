import SwiftUI

struct ScannerView: View {
    @State private var vm = ScannerViewModel()

    var body: some View {
        if vm.state == .permissionDenied {
            DeniedPermissions()
        } else {
            NavigationStack {
                ZStack {
                    CameraPreview(session: vm.previewSession)
                        .accessibilityHidden(true)
                    ScannerOverlayView()
                }
                .onChange(of: vm.state) { _, newState in
                    if case .detected(let code) = newState {
                        UIAccessibility.post(
                            notification: .announcement,
                            argument: code
                        )
                    }
                }
                .overlay(alignment: .bottom) {
                    switch vm.state {
                    case .detected(let code):
                        Text(code)
                            .font(Font.qsVerdict)
                            .foregroundStyle(Color.qsSafe)
                    case .idle:
                        Text("No Code detected")
                            .font(Font.qsVerdict)
                            .foregroundStyle(Color.qsWarning)
                    case .scanning:
                        Text("Scanning...")
                            .font(Font.qsVerdict)
                            .foregroundStyle(Color.qsWarning)
                    case .permissionDenied:
                        Text("PermissionDenied")
                            .font(Font.qsVerdict)
                            .foregroundStyle(Color.qsWarning)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                TorchButton(isTorchOn: vm.isTorchOn, onToggle: vm.toggleTorch)
            }
            .overlay(alignment: .topLeading) {
                #if DEBUG
                    Button("Inject") {
                        vm.handleDetected("https://carlosdaniel.dev")
                    }
                #endif
            }
            .onDisappear {
                Task { await vm.stop() }
            }
            .onTapGesture {
                vm.reset()
            }
            .accessibilityAction(named: "Reset") {
                vm.reset()
            }
            .task {
                await vm.start()
            }

        }
    }
}

#Preview {
    ScannerView()
}
