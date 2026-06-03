import SwiftUI

struct QRCodesSupported: View {
    private let qrCodes = QRPayload.allCases.map(\.rawValue)
    
    func showQRCodesSupported() -> some View {
        HStack {
            ForEach(qrCodes, id: \.self) { code in
                Pill(value: code, color: .red, size: .medium)
            }
        }
    }

    var body: some View {
        showQRCodesSupported()
    }
}
