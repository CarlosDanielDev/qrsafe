import Foundation

struct SubdomainDepthCheckerService: URLChecking {
    nonisolated init() {}

    nonisolated func check(url: ParsedURL) -> String? {
        let minSuspiciousLabels = 5
        let labels = url.host.split(separator: ".").count

        if labels >= minSuspiciousLabels {
            return "Too many subdomains"
        }

        return nil
    }
}
