import AVFoundation
import Observation

@Observable
@MainActor
final class ScannerViewModel {
    private(set) var state: ScanState = .idle
    private let cameraService = CameraService()
    var previewSession: AVCaptureSession { cameraService.session }
    
    func handleDetected(_ code: String) {
        state = .detected(code)
    }
    
    func reset() {
        state = .scanning
    }
    
    func start() async {
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
        await cameraService.onScan { [weak self] code in
            guard let viewModel = self else { return }
            Task { @MainActor in
                viewModel.handleDetected(code)
            }
        }
        await cameraService.start()
        state = .scanning
    }
    
    func stop() async {
        await cameraService.stop()
    }
}
