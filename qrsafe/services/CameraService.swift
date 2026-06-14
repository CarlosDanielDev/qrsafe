import AVFoundation
import SwiftUI

enum CameraState: String, Equatable {
    case idle, configured, running, stopped
}

actor CameraService {
    private let session = AVCaptureSession()
    private var state: CameraState = .idle

    func configure() {
        guard state == .idle else { return }
        session.beginConfiguration()
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
