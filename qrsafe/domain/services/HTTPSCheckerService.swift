import Foundation

struct HTTPSCheckerService: URLChecking {
    nonisolated init() {}

    nonisolated func check(url: ParsedURL) -> String? {
        let isHttpOnly = url.scheme.lowercased() == "http"
        
        if isHttpOnly {
            return "http only"
        }
        
        return nil
    }
}
