import AVFoundation
import Foundation

class MetadataReceiver: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    nonisolated override init() {
        super.init()
    }

    nonisolated func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        print("Camera saw a code")
    }
}

enum CameraState: String, Equatable {
    case idle, configured, running, stopped
}

actor CameraService {
    nonisolated let session = AVCaptureSession()
    private var state: CameraState = .idle
    let receiver = MetadataReceiver()

    func configure() {
        guard state == .idle else { return }
        session.beginConfiguration()
        guard
            let device = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .back
            )
        else {
            session.commitConfiguration()
            return
        }
        captureDeviceInput(session: session, device: device)
        captureDeviceOutput(session: session)

        session.commitConfiguration()
        state = .configured
    }

    func captureDeviceOutput(session: AVCaptureSession) {
        let queue = DispatchQueue(label: "qrsafe.metadata")
     

        let output = AVCaptureMetadataOutput()

        guard session.canAddOutput(output) else {
            session.commitConfiguration()
            return
        }
        session.addOutput(output)
        output.metadataObjectTypes = [.qr]
        output.setMetadataObjectsDelegate(receiver, queue: queue)
    }

    func captureDeviceInput(session: AVCaptureSession, device: AVCaptureDevice)
    {
        do {
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input) else {
                session.commitConfiguration()
                return
            }

            session.addInput(input)
        } catch {
            session.commitConfiguration()
            return
        }

    }

    func start() {
        guard state == .configured else { return }
        session.startRunning()
        state = .running
    }

    func stop() {
        guard state == .running else { return }
        session.stopRunning()
        state = .idle
    }
}
