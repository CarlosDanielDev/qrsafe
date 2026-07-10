import Foundation

struct SafetyReport: Equatable {
    let parsedUrl: ParsedURL
    let findings: [String]
}
