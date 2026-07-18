import Foundation

struct HomographCheckerService: URLChecking {
    nonisolated init() {}

    nonisolated func check(url: ParsedURL) -> String? {
        let punycodePrefix = "xn--"
        let labels = url.host
            .split(separator: ".")
            .map(String.init)

        let hasPunycodePrefix = labels.contains {
            $0.hasPrefix(punycodePrefix)
        }

        if hasPunycodePrefix {
            return "punycode-encoded domain"
        }

        let isAllASCII = url.host
            .unicodeScalars
            .allSatisfy(\.isASCII)

        if !isAllASCII {
            return "non-Latin characters in domain"
        }
        
        return nil
    }
}
