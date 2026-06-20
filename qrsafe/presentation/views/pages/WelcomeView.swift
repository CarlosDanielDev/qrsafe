
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.qsWarning)
                
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 70))
                    .foregroundStyle(.qsBackground)
            }
            
            Text("Welcome to QRSafe!")
                .font(.qsTitle)
                .fontWeight(.semibold)
                .padding(.top)

            Text("Scan a QRCode. Know if it's safe before you tap.")
                .font(.qsTitle2)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
