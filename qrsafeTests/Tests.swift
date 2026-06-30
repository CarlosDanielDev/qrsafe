import AVFoundation
import Testing

@testable import qrsafe

class FakeSession: CaptureSessionProviding {
    var session: AVCaptureSession = AVCaptureSession()
    var capturedHandler: ((String) -> Void)?

    func configure() async {}
    func start() async {}
    func stop() async {}
    func onScan(_ handler: @escaping @Sendable (String) -> Void) async {
        capturedHandler = handler
    }

    func simulateDetection(_ code: String) {
        capturedHandler?(code)
    }
}

struct CheckerTests {
    @Test func defaultNameDerivesFromType() {
        #expect(AlwaysTypeSafe().name == "AlwaysTypeSafe")
    }

    @Test func alawaysSafeCheckerPasses() {
        #expect(AlwaysTypeSafe().check(.URL) == true)
    }
}

struct StringURLTests {
    @Test func httpsIsLikelyURL() {
        #expect("https://google.com".isLikelyURL == true)
    }

    @Test func normalTextIsNotURL() {
        #expect("Hello World".isLikelyURL == false)
    }
}

struct ScanCounterTests {

    @Test func recordScanConcurrentlyWithoutLosingUpdate() async {
        let counter = ScanCounter()
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<1000 {
                group.addTask { await counter.record() }
            }

        }

        #expect(await counter.total == 1000)
    }

    @MainActor
    @Test func modelMirrorCounterTotal() async {
        let counter = ScanCounter()
        await counter.record()
        await counter.record()
        let model = ScanCounterModel()
        await model.refresh(from: counter)
        #expect(model.displayCount == 2)
    }
}

struct ScannerViewModelTests {

    @MainActor
    @Test func startsIdle() {
        let vm = ScannerViewModel()
        #expect(vm.state == .idle)
    }

    @MainActor
    @Test func resetReturnsToScanning() {
        let vm = ScannerViewModel()
        vm.reset()
        #expect(vm.state == .scanning)
    }

    @MainActor
    @Test func handleDetectedMovesToDetected() {
        let stringDetected = "https://carlosdaniel.dev"
        let vm = ScannerViewModel()
        vm.handleDetected(stringDetected)
        #expect(vm.state == .detected(stringDetected))

    }

    @MainActor
    @Test func injectCustomSession() async {
        let fake = FakeSession()
        let vm = ScannerViewModel(camera: fake)
        await vm.start()
        fake.simulateDetection("https://evil.com")
        await Task.yield()
        #expect(vm.state == .detected("https://evil.com"))
    }
}
