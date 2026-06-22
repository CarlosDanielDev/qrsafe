import Foundation

enum ScanState: Equatable {
    case idle, scanning, permissionDenied
    case detected(String)
}
