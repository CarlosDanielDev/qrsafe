import AVFoundation

protocol CaptureSessionProviding {
    var session: AVCaptureSession { get }
    func start() async
    func stop() async
    func onScan(_ handler: @escaping @Sendable (String) -> Void) async
    func configure() async
}
