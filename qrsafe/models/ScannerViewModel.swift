import AVFoundation
import Observation

@Observable
@MainActor
final class ScannerViewModel {
    private(set) var state: ScanState = .idle
    private let cameraService = CameraService()
    private let feedbackService: FeedbackPoviding
    var previewSession: AVCaptureSession { cameraService.session }

    init(feedback: FeedbackPoviding? = nil) {
        self.feedbackService = feedback ?? FeedbackService()
    }

    func handleDetected(_ code: String) {
        var wasDetected = false
        if case .detected = state { wasDetected = false }
        state = .detected(code)
        if !wasDetected {
            feedbackService.success()
        }

    }

    func reset() {
        state = .scanning
    }

    func start() async {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        let granted: Bool = await checkPermissions()
        
        guard granted else {
            state = .permissionDenied
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

    func checkPermissions() async -> Bool {
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
        return granted
    }
}
