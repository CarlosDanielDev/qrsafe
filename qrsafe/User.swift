import SwiftUI

struct User: View {
    var username: String?

    var body: some View {
        VStack(spacing: 16) {
            if let safeUsername = username {
                Text(
                    "Hello, world! \(safeUsername), your username has \(safeUsername.count) characters"
                )
                .foregroundStyle(Color.primary)
                .multilineTextAlignment(.center)
                .padding()
            }
        }
    }
}
