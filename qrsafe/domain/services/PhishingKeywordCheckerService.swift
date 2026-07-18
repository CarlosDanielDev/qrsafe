import Foundation

struct PhishingKeywordCheckerService: URLChecking {
    nonisolated init() {}

    nonisolated func check(url: ParsedURL) -> String? {
        guard
            let fileURL = Bundle.main.url(
                forResource: "phishing-keywords",
                withExtension: "json"
            ), let data = try? Data(contentsOf: fileURL),
            let phishingKeywords = try? JSONDecoder().decode(
                [String].self,
                from: data
            )
        else {
            return nil
        }
        let keywords = Set(phishingKeywords)
        let host = url.host.lowercased()
        let path = url.path.lowercased()
        let haystack = "\(host)\(path)"

        let matchedKeywords = keywords.filter {
            haystack.contains($0)
        }

        if !matchedKeywords.isEmpty {
            return
                "has phishing keywords in host or path: \(matchedKeywords.joined(separator: ", "))"
        }

        return nil
    }
}
