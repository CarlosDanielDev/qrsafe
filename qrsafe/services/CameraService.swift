import AVFoundation
import SwiftUI

enum CameraState: String, Equatable {
    case idle, configured, running, stopped
}

actor CameraService {
    nonisolated let session = AVCaptureSession()
    private var state: CameraState = .idle

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

        session.commitConfiguration()
        state = .configured
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
