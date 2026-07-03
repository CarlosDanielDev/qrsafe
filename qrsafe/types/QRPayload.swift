import Foundation

enum QRPayload {
    case url(Foundation.URL)
    case text(String)
    case other(String)
}
