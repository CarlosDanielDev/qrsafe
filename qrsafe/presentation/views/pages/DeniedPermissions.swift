import SwiftUI

struct DeniedPermissions: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Permissions denied")
                Text("Please, allow the permissions in settings")
                Button("Settings") {
                    UIApplication.shared.open(
                        URL(string: UIApplication.openSettingsURLString)!
                    )
                }
            }
        }
    }
}
