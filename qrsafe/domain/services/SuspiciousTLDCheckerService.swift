import Foundation

struct SuspiciousTLDCheckerService: URLChecking {
    nonisolated init() {}

    nonisolated func check(url: ParsedURL) -> String? {
        guard
            let fileURL = Bundle.main.url(
                forResource: "suspicious-tlds",
                withExtension: "json"
            ), let data = try? Data(contentsOf: fileURL),
            let domains = try? JSONDecoder().decode([String].self, from: data)
        else {
            return nil
        }
        let suspiciousTLDs = Set(domains)

        guard
            let tld = url.host.split(separator: ".").last.map(
                String.init
            )?.lowercased()
        else {
            return nil
        }

        if suspiciousTLDs.contains(tld) {
            return "known suspicious TLD"
        }

        return nil
    }
}
