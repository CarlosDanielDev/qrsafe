import Foundation

enum URLParserService {
    static func parse(_ url: String) -> QRPayload {
        if url.hasPrefix("WIFI:") || url.hasPrefix("BEGIN:VCARD")
            || url.hasPrefix("smsto:")
        {
            return .other(url)
        }

        if let parsed = URL(string: url),
            let scheme = parsed.scheme,
            scheme == "http" || scheme == "https",
            parsed.host != nil
        {
            return .url(parsed)
        }

        return .text(url)
    }
}
