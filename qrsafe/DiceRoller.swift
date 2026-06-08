import SwiftUI

struct DiceRoller: View {
    @State private var numberOfDice: Int = 1

    var body: some View {

        VStack {
            Text("Dice Roller")
                .font(.largeTitle.lowercaseSmallCaps().bold())
                .foregroundStyle(.white)

            HStack {
                ForEach(1...numberOfDice, id: \.description) { _ in
                    DiceView()
                }
            }

            HStack {
                Button("Remove Dice", systemImage: "minus.circle.fill") {
                    withAnimation {
                        numberOfDice -= 1
                    }
                }
                .disabled(numberOfDice == 1)

                Button("Add Dice", systemImage: "plus.circle.fill") {
                    withAnimation {
                        numberOfDice += 1
                    }
                }
                .disabled(numberOfDice == 6)
            }
            .padding()
            .labelStyle(.iconOnly)
            .font(.title)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.diceBackground)
        .tint(.white)

    }

}

#Preview {
    DiceRoller()
}
