import SwiftUI

struct TimeUpdate: View {
    let greenTime = 1...18
    let orangeTime = 19...20
    let redTime = 21...23

    func checkTime(time: Int) -> Color {

        switch time {
        case greenTime: return Color.accentColor
        case orangeTime: return Color.orange
        default: return Color.red
        }
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { dateTime in
            let currentTime = Calendar.current.component(.hour, from: .now)
            let currentColor = checkTime(time: currentTime)
            let currentDateLive = dateTime.date.formatted(
                date: .omitted,
                time: .standard
            )

            Text(currentDateLive)
                .font(.largeTitle)
                .foregroundStyle(currentColor)
                .bold()

        }
    }
}
