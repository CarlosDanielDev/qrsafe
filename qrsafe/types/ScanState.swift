import Foundation

enum ScanState: Equatable {
    case idle, scanning
    case detected(String)
}
