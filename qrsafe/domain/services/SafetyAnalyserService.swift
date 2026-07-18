import Foundation

actor SafetyAnalyserService {
    private let checkers: [URLChecking]

    init(
        checkers: [URLChecking] = [
            HTTPSCheckerService(),
            IPHostCheckerService(),
            ShortenerCheckerService(),
            SuspiciousTLDCheckerService(),
            SubdomainDepthCheckerService(),
            HomographCheckerService(),
            PhishingKeywordCheckerService(),
        ]
    ) {
        self.checkers = checkers
    }

    func analyze(parsed: ParsedURL) async -> SafetyReport {
        let findings = checkers.compactMap { $0.check(url: parsed) }

        return SafetyReport(parsedUrl: parsed, findings: findings)
    }
}
