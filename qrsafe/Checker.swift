import Foundation

protocol Checker {
    var name: String { get }
    func check(_ payload: QRPayload) -> Bool
}


extension Checker {
    var name: String { String(describing: Self.self) }
}


struct AlwaysTypeSafe: Checker {
    func check(_ payload: QRPayload) -> Bool {
        return true
    }
}


