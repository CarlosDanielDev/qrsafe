import AVFoundation
import SwiftUI

struct ScannerView: View {
    @State private var lastCode: String?

    private let cameraService = CameraService()

    var body: some View {
        NavigationStack {
            CameraPreview(session: cameraService.session)
                .navigationTitle("Scanner")
                .overlay(alignment: .bottom) {
                    if let lastCode {
                        Text(lastCode)
                            .font(Font.qsVerdict)
                            .foregroundStyle(Color.qsSafe)
                    } else {
                        Text("No Code detected")
                            .font(Font.qsVerdict)
                            .foregroundStyle(Color.qsWarning)
                    }
                }
        }
        .task {
            await cameraService.configure()
            await cameraService.start()
        }
        .onDisappear {
            Task { await cameraService.stop() }
        }
        .task {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            let granted: Bool
            switch status {
            case .authorized:
                granted = true
            case .notDetermined:
                granted = await AVCaptureDevice.requestAccess(for: .video)
            case .restricted, .denied:
                granted = false
            @unknown default:
                granted = false
            }

            guard granted else {
                return
            }
            await cameraService.configure()
            await cameraService.onScan { code in
                Task { @MainActor in
                    lastCode = code
                }
            }
            await cameraService.start()
        }

    }
}
