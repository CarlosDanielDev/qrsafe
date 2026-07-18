import Foundation
import Network

struct IPHostCheckerService: URLChecking {
    nonisolated init() {}

    nonisolated func check(url: ParsedURL) -> String? {
        var hasIpAddress: Bool {
            let host = url.host
            let cleaned = host.trimmingCharacters(in: .init(charactersIn: "[]"))

            if IPv4Address(cleaned) != nil {
                return true
            }

            if IPv6Address(cleaned) != nil {
                return true
            }

            return false
        }

        if hasIpAddress {
            return "raw IP address as host"
        }

        return nil
    }
}
