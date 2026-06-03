import SwiftUI

struct DefaultText: View {
    var value: String?
    var isLarge: Bool?

    var body: some View {
        if let value {
            defaultText(text: value)
        } else {
            defaultText(text: "-")
        }
    }

    func defaultText(text: String, isLarge: Bool? = false) -> some View {
        Text(text)
            .foregroundStyle(Color.primary)
            .multilineTextAlignment(.center)
            .padding()
            .font(.body)
    }
}
