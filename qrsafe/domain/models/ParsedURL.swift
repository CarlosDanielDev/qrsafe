import Foundation

struct ParsedURL: Equatable {
    let scheme: String
    let host: String
    let path: String
    let rawURL: String

    init?(url: URL) {
        guard
            let components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false
            ),
            let scheme = components.scheme,
            let host = components.host
        else {
            return nil
        }
        self.scheme = scheme
        self.host = host
        self.path = components.path
        self.rawURL = url.absoluteString
    }
}
