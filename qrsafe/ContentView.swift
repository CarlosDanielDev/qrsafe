import SwiftUI

struct ContentView: View {
    
    let appName = "QRSafe"
    
    var body: some View {
        VStack(spacing: 15) {
            Text(appName)
                .font(.largeTitle)
                .foregroundStyle(Color.primary)
            
            TimeUpdate()
            
            User(username: "@carlosdanieldev")
            QRCodesSupported()
        }
    }

}
#Preview {
    ContentView()
}
