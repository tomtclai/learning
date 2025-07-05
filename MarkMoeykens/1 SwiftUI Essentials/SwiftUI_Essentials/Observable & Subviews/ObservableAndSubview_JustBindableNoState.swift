// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ObservableAndSubview_JustBindableNoState: View {
    @Bindable private var oo = ForecastOO()
    
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

#Preview {
    ObservableAndSubview_JustBindableNoState()
}
