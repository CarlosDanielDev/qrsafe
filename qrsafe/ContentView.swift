import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            WelcomeView()
            HomeView()
        }
        .tabViewStyle(.page)
            
    }

}
#Preview {
    ContentView()
}
