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
        let url: ParsedURL? = ParsedURL(
            url: URL(string: "https://sub.example.com/path?key=val")!
        )
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

    @Test func reportsRawIPFinding() async {
        let analyser = SafetyAnalyserService()
        let url = URL(string: "http://192.168.0.1/login")!
        let parsed = await ParsedURL(url: url)!
        let report = await analyser.analyze(parsed: parsed)

        #expect(report.findings.count == 2)
    }

    @Test func reportsShortenedURLFinding() async {
        let analyser = SafetyAnalyserService()
        let url = URL(string: "http://bit.ly/abc")!
        let parsed = await ParsedURL(url: url)!
        let report = await analyser.analyze(parsed: parsed)

        #expect(report.findings.count == 2)
    }

    @Test func reportsGenericTLDs() async {
        let analyser = SafetyAnalyserService()
        let url = URL(string: "http://test.zip/abc")!
        let parsed = await ParsedURL(url: url)!
        let report = await analyser.analyze(parsed: parsed)

        #expect(report.findings.count == 2)
    }

}

struct HTTPSCheckerServiceTests {
    @Test(arguments: [
        ("https://carlosdaniel.dev", false),
        ("http://evil.com", true),
    ]) func flagInsecureScheme(urlScheme: String, expectFindings: Bool) async {
        let url = URL(string: urlScheme)!
        let parsed = await ParsedURL(url: url)!
        let findings = HTTPSCheckerService().check(url: parsed)

        #expect((findings != nil) == expectFindings)
    }
}

struct IPHostCheckerServiceTests {
    @Test(arguments: [
        ("http://192.168.0.1/login", true),
        ("http://[2001:db8::1]/", true),
        ("https://carlodaniel.dev", false),
        ("http://1.2.3.4.evil.com", false),
        ("http://999.999.999.999", false),
    ]) func flagInsecureIp(urlScheme: String, expectFindings: Bool) async {
        let url = URL(string: urlScheme)!
        let parsed = await ParsedURL(url: url)!
        let findings = IPHostCheckerService().check(url: parsed)

        #expect((findings != nil) == expectFindings)
    }
}

struct ShortenerCheckerServiceTests {
    @Test(arguments: [
        ("https://bit.ly/abc", true),
        ("https://tinyurl.com/xyz", true),
        ("https://carlosdaniel.dev", false),
        ("https://notbit.ly", false),
    ]) func flagShortenerUrls(urlScheme: String, expectFindings: Bool) async {
        let url = URL(string: urlScheme)!
        let parsed = await ParsedURL(url: url)!
        let findings = ShortenerCheckerService().check(url: parsed)

        #expect((findings != nil) == expectFindings)
    }
}

struct SuspiciousTLDCheckerServiceTests {
    @Test(arguments: [
        ("https://test.zip/abc", true),
        ("https://test.tk/xyz", true),
        ("https://zip.carlosdaniel.dev", false),
        ("https://apple.com", false),
    ]) func flagSuspiciousTLD(urlScheme: String, expectFindings: Bool) async {
        let url = URL(string: urlScheme)!
        let parsed = await ParsedURL(url: url)!
        let findings = SuspiciousTLDCheckerService().check(url: parsed)

        #expect((findings != nil) == expectFindings)
    }
}
