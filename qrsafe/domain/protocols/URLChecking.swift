import Foundation

protocol URLChecking {
    nonisolated func check(url: ParsedURL) -> String?
}
