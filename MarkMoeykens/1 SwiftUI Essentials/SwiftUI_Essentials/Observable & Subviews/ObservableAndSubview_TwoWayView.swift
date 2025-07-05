// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ObservableAndSubview_TwoWayView: View {
    @State private var oo = ForecastOO()
    
    var body: some View {
        NavigationStack {
            VStack {
                EditableWeatherView(forecast: oo)
                
                Divider()
                
                Text(oo.sevenDays.map {$0.day}, format: .list(type: .and, width: .narrow) )
            }
            .font(.title)
            .navigationTitle("Weather")
        }
    }
}

struct EditableWeatherView: View {
    @Bindable var forecast: ForecastOO
    
    var body: some View {
        List($forecast.sevenDays) { $day in
            Label(
                title: {
                    TextField("Day", text: $day.day)
                        .textFieldStyle(.roundedBorder)
                },
                icon: { Image(systemName: day.icon) }
            )
        }
        .tint(.pink)
    }
}

#Preview {
    ObservableAndSubview_TwoWayView()
}

#Preview("EditableWeatherView", traits: .sizeThatFitsLayout) {
    @Previewable @State var oo = ForecastOO()
    EditableWeatherView(forecast: oo)
}
