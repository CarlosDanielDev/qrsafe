import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            Tab("Scan", systemImage: "qrcode.viewfinder") {
               ScannerView()
            }
            Tab("History", systemImage: "clock.arrow.circlepath") {
               HistoryView()
            }
            Tab("Settings", systemImage: "gearshape") {
               SettingsView()
            }
        }
    }
}
