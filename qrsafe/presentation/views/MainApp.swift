import SwiftUI

let gradientColors: [Color] = [
    .qsAccent,
    .qsSafe
]


@main
struct MainApp: App {

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
