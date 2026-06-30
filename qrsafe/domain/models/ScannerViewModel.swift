import AVFoundation
import Observation

@Observable
@MainActor
final class ScannerViewModel {
    private(set) var state: ScanState = .idle
    private(set) var isTorchOn = false
    private let cameraService: CaptureSessionProviding
    private let feedbackService: FeedbackPoviding
    private(set) var lastDetectedCode: String?
    private(set) var lastDetectedAt: Date?

    var previewSession: AVCaptureSession { cameraService.session }

    init(feedback: FeedbackPoviding? = nil, camera: CaptureSessionProviding? = nil) {
        self.feedbackService = feedback ?? FeedbackService()
        self.cameraService = camera ?? CameraService()
    }

    func handleDetected(_ code: String) {
        let now = Date()
        let isEqualCode = code == lastDetectedCode
        let validLastDate = lastDetectedAt ?? now
        let elapsedSeconds = Date().timeIntervalSince(validLastDate)
        let threshold = ModelConstants.THRESHOLD
        
        if isEqualCode && elapsedSeconds < threshold { return }
        
        lastDetectedCode = code
        lastDetectedAt = now
        
        var wasDetected = false
        if case .detected = state { wasDetected = false }
        state = .detected(code)
        if !wasDetected {
            feedbackService.success()
        }

    }

    func reset() {
        lastDetectedAt = nil
        lastDetectedCode = nil
        state = .scanning
    }

    func start() async {
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

    func toggleTorch() {
        isTorchOn.toggle()
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch
        else {
            print("Torch is not available on this device simulator.")
            return
        }

        do {
            try device.lockForConfiguration()

            device.torchMode = isTorchOn ? .on : .off

            device.unlockForConfiguration()
        } catch {
            print(
                "Could not lock configuration or toggle torch: \(error.localizedDescription)"
            )
        }
    }
}
