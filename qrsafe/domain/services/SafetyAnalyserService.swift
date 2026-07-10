import Foundation

actor SafetyAnalyserService {
   
    func analyze(parsed: ParsedURL) async -> SafetyReport {
        return SafetyReport(
            parsedUrl: parsed, findings: []
        )
    }
}
