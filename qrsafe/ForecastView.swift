import SwiftUI

struct ForecastView: View {
    var body: some View {
        HStack {
            DayForecast(
                day: "Mon",
                isRainy: false,
                high: 70,
                low: 50
            )
            DayForecast(
                day: "Tue",
                isRainy: true,
                high: 70,
                low: 50
            )

        }
    }

}

struct DayForecast: View {
    var day: String
    var isRainy: Bool
    var high: Int
    var low: Int
    
    var iconName: String {
        if isRainy {
            return "cloud.rain.fill"
        }
        return "sun.max.fill"
    }
    
    var iconColor: Color {
        if isRainy {
            return Color.blue
        }
        
        return Color.yellow
    }
    
    var body: some View {
        VStack {
            Text(day)
                .font(Font.headline)
            Image(systemName: iconName)
                .foregroundStyle(iconColor)
                .font(Font.largeTitle)
                .padding(5)
            Text("Hight: \(high)")
                .fontWeight(Font.Weight.semibold)
            Text("Low: \(low)")
                .fontWeight(Font.Weight.medium)
                .foregroundStyle(Color.secondary)
        }
        .padding()
    }
}

#Preview {
    ForecastView()
}
