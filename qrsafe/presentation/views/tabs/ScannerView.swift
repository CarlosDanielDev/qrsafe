import SwiftUI

struct ScannerView: View {
    @State private var vm = ScannerViewModel()

    var body: some View {
        NavigationStack {
            CameraPreview(session: vm.previewSession)
                .navigationTitle("Scanner")
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
                    }

                }
        }
        .onDisappear {
            Task { await vm.stop() }
        }
        .onTapGesture {
            vm.reset()
        }
        .task {
            await vm.start()
        }
    }
}
