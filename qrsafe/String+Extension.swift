import Foundation

extension String {
    var isLikelyURL: Bool {
        guard let url = URL(string: self),
              let scheme = url.scheme,
              ["https", "http"].contains(scheme),
              url.host != nil else { return false }
        return true
    }
}
