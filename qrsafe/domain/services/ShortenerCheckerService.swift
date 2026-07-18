import Foundation

struct ShortenerCheckerService: URLChecking {
    nonisolated init() {}

    nonisolated func check(url: ParsedURL) -> String? {
        guard
            let fileURL = Bundle.main.url(
                forResource: "url-shorteners",
                withExtension: "json"
            ), let data = try? Data(contentsOf: fileURL),
            let domains = try? JSONDecoder().decode([String].self, from: data)
        else {
            return nil
        }
        let shorteners = Set(domains)

        if shorteners.contains(url.host.lowercased()) {
            return "known URL shortener"
        }

        return nil
    }
}
