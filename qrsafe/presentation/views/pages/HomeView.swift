import AVFoundation
import SwiftUI

struct HomeView: View {
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)

            var isAuthorized = status == .authorized

            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }

            return isAuthorized
        }
    }
    
    func setUpCaptureSession() async {
        guard await isAuthorized else {
            return
        }
    }

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
        .task {
            await setUpCaptureSession()
        }
    }
}
