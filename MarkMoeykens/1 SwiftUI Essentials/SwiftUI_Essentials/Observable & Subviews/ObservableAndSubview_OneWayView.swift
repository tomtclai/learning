// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

// View
import SwiftUI

struct ObservableAndSubview_OneWayView: View {
    private var oo = ForecastOO()
    
    var body: some View {
        NavigationStack {
            VStack {
                WeatherView(forecast: oo)
                
                Button("Update") {
                    oo.updateSunday()
                }
                .buttonStyle(.borderedProminent)
            }
            .font(.title)
            .navigationTitle("Weather")
        }
    }
}

struct WeatherView: View {
    var forecast: ForecastOO
    
    var body: some View {
        List(forecast.sevenDays) { day in
            Label(day.day, systemImage: day.icon)
        }
        .tint(.pink)
    }
}

#Preview {
    ObservableAndSubview_OneWayView()
}


// Observable Object

@Observable
class ForecastOO {
    var sevenDays = [Weather]()
    
    struct Weather: Identifiable {
        let id = UUID()
        var day = ""
        var icon = ""
    }
    
    init() {
        sevenDays = [
            Weather(day: "Sunday", icon: "cloud.snow.fill"),
            Weather(day: "Monday", icon: "sun.min.fill"),
            Weather(day: "Tuesday", icon: "sun.max.fill"),
            Weather(day: "Wednesday", icon: "cloud.sun.fill"),
            Weather(day: "Thursday", icon: "sun.min.fill"),
            Weather(day: "Friday", icon: "cloud.drizzle.fill"),
            Weather(day: "Saturday", icon: "cloud.sleet.fill"),
        ]
    }
    
    func updateSunday() {
        sevenDays[0].day = "Sunday (updated)"
        sevenDays[0].icon = "cloud.sun.fill"
    }
}

