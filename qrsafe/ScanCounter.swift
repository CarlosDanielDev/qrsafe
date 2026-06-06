import SwiftUI

actor ScanCounter {
    private(set) var total: Int = 0
    
    func record() {
        total += 1
    }
}
