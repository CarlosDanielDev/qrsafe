import SwiftUI

struct User: View {
    var username: String?

    var body: some View {
        VStack(spacing: 16) {
            if let safeUsername = username {
                let value = "Hello, world! \(safeUsername), your username has \(safeUsername.count) characters"
                DefaultText(value: value)
            } else {
                DefaultText()
            }
        }
    }
}
