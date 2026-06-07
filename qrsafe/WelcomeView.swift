
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.tint)
                
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 70))
                    .foregroundStyle(Color.white)
                
//                Image(systemName: "lock.shield.fill")
//                    .font(.system(size: 30))
//                    .foregroundStyle(Color.white)
//                    .position(x: 230, y: 300)
            }
            
            Text("Welcome to QRSafe!")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top)

            Text("Scan a QRCode. Know if it's safe before you tap.")
                .font(.title2)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
