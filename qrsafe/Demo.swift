import SwiftUI

struct Demo: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Image(systemName: "arrow.2.circlepath")
                        .resizable()
                        .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * 0.25,  height: geometry.size.width * 0.25)
                )
                .padding()
                
                Text("Hello, World!")
                    .padding(.top, 16)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .border(Color.red)

        }
    }
}

#Preview {
    Demo()
}
