import AVFoundation
import Foundation
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
        #expect(
            AlwaysTypeSafe().check(.url(URL(string: "https://example.com")!))
                == true
        )
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

struct ParsedURLTests {
    @Test func sameURLsAreEqual() {
         let urlA: ParsedURL? = ParsedURL(
            url: URL(string: "https://example.com")!
        )
         let urlB: ParsedURL? = ParsedURL(
            url: URL(string: "https://example.com")!
        )
        
        #expect(urlA == urlB)
    }
    
    @Test func parseAllFields() {
        let url: ParsedURL? = ParsedURL(url: URL(string:  "https://sub.example.com/path?key=val")!)
        #expect(url?.scheme == "https")
        #expect(url?.host == "sub.example.com")
        #expect(url?.path == "/path")
    }
    
    @Test func compareDifferentURL() {
        let urlA: ParsedURL? = ParsedURL(
            url: URL(string: "https://example.com")!
        )
        
        let urlB: ParsedURL? = ParsedURL(
            url: URL(string: "http://example.com")!
        )

        #expect(urlA != urlB)
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

struct URLParserServiceTests {
    @Test func httpsURLParsesAsURL() {
        let result = URLParserService.parse("https://example.com")
        if case .url = result {} else { Issue.record("Expected .url") }
    }

    @Test func wifiQRCodeLParsesAsWIFI() {
        let result = URLParserService.parse("WIFI:")
        if case .other = result {} else { Issue.record("Expected .other") }
    }

    @Test func normalTextParsesAsTEXT() {
        let result = URLParserService.parse("hey you!")
        if case .text = result {} else { Issue.record("Expected .text") }
    }

    @Test func emptyStringParsesAsEmptyTEXT() {
        let result = URLParserService.parse("")
        if case .text = result {} else { Issue.record("Expected .text") }
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

struct SafetyAnalyzerTests {
    @Test func hasCorrectSafetyReportShape() async {
        let analyzer = SafetyAnalyserService()
        let url = URL(string: "https://evil.com")!
        let parsed = await ParsedURL(url: url)!
        let report = await analyzer.analyze(parsed: parsed)
        
        #expect(report.findings.isEmpty)
        #expect(report.parsedUrl == parsed)
    }
    
    @Test func hasFindingsOnTheReport() async {
        let analyser = SafetyAnalyserService()
        let url = URL(string: "http://evil.com")!
        let parsed = await ParsedURL(url: url)!
        let report = await analyser.analyze(parsed: parsed)
        
        #expect(report.findings.count == 1)
    }
    
}


struct HTTPSCheckerServiceTests {
    @Test(arguments: [
        ("https://carlosdaniel.dev", false),
        ("http://evil.com", true)
    ]) func flagInsecureScheme(urlScheme: String, expectFindings: Bool) async {
        let url = URL(string: urlScheme)!
        let parsed = await ParsedURL(url: url)!
        let findings = HTTPSCheckerService().check(url: parsed)
        
        #expect((findings != nil) == expectFindings)
    }
}
