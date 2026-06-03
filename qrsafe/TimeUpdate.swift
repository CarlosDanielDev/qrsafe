import SwiftUI

struct TimeUpdate: View {
    private let blueTime: ClosedRange<Int> = 0...7
    private let greenTime: ClosedRange<Int> = 8...17
    private let orangeTime: ClosedRange<Int> = 18...21
    private let redTime: ClosedRange<Int> = 22...23
    
    @State private var isMidnight: Bool = false

    func checkTime(time: Int) -> Color {
        switch time {
        case blueTime: return Color.blue
        case greenTime: return Color.green
        case orangeTime: return Color.orange
        default: return Color.red
        }
    }
    
    func checkIsMidnight() {
        let now = Date()
        let calendart = Calendar.current
        isMidnight = now == calendart.startOfDay(for: now)
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { dateTime in
            let currentTime = Calendar.current.component(.hour, from: .now)
            
            let currentColor = checkTime(time: currentTime)
            
            let currentDateLive = dateTime.date.formatted(
                date: .omitted,
                time: .standard
            )
            
            let formattedText = isMidnight ? "0\(currentDateLive)" : currentDateLive

            Text(formattedText)
                .font(.largeTitle)
                .foregroundStyle(currentColor)
                .bold()

        }
        .onAppear {
            checkIsMidnight()
        }
    }
}
